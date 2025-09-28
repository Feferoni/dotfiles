#!/usr/bin/env python3

import os
import sys
import subprocess
import glob


def get_stdin():
    try:
        import select
        if select.select([
                sys.stdin,
        ], [], [], 2.0)[0]:
            return sys.stdin.read().strip()
    except ImportError:
        pass
    return None


def remote_open(socket, win_id, pane_id, file):
    subprocess.run([
        'nvim', '--server', socket, '--remote-send',
        f"<esc>:OpenFile {file}<cr>"
    ])
    subprocess.run(['tmux', 'selectw', '-t', win_id])
    subprocess.run(['tmux', 'selectp', '-t', pane_id])
    sys.exit(0)


def get_tmux_data(args):
    return subprocess.run(args, capture_output=True, text=True).stdout.strip()


def main():
    file_path = get_stdin() or (sys.argv[1] if len(sys.argv) > 1 else None)
    if not file_path:
        print("No file provided for opening")
        sys.exit(1)

    file_path = file_path.strip()
    file = os.path.realpath(file_path.split(':')[0])
    if not os.path.exists(file):
        print(f"Couldn't open file {file_path}")
        sys.exit(1)

    runtime_dir = os.environ.get(
        'XDG_RUNTIME_DIR',
        f"{os.environ.get('TMPDIR', '/tmp')}/nvim.{os.environ['USER']}")
    listen_socks = glob.glob(f"{runtime_dir}/**/nvim.*.0", recursive=True)
    listen_socks = ':'.join(listen_socks).split(':') if listen_socks else []

    panes = get_tmux_data([
        'tmux', 'list-panes', '-a', '-F',
        '#{session_name} #{window_index} #{pane_index} #{pane_pid}'
    ]).split("\n")

    current_window_id = get_tmux_data(
        ['tmux', 'display-message', '-p', '#{window_index}'])
    current_session_name = get_tmux_data(
        ['tmux', 'display-message', '-p', '#{session_name}'])

    sock, win_id, pane_id = None, None, None

    for pane in panes:
        pane_ids = pane.split()
        session_name, win_id, pane_id, pid = pane_ids

        try:
            cpid = subprocess.run(['pgrep', '-P', pid, 'nvim'],
                                  capture_output=True,
                                  text=True).stdout.strip()
        except subprocess.CalledProcessError:
            cpid = None

        ppid = subprocess.run(['pgrep', '-P', cpid, 'nvim'],
                              capture_output=True,
                              text=True).stdout.strip() if cpid else '0'

        for lsock in listen_socks:
            if f"nvim.{ppid}." in lsock:
                if session_name == current_session_name and win_id == current_window_id:
                    remote_open(lsock, win_id, pane_id, file)
                elif not sock:
                    sock, win_id, pane_id = lsock, win_id, pane_id

    if sock:
        remote_open(sock, win_id, pane_id, file)

    subprocess.run(['tmux', 'send-keys', f"nvim {file}", 'Enter'])


if __name__ == "__main__":
    main()

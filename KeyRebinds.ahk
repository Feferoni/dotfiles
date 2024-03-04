#Requires AutoHotkey v2.0
; Make Caps Lock act as a modifier key when held down with another key, but retain its original function when pressed alone.

; Mappings
; 1:  !  2:  "  3:  #  4:  %  5:     6:     7:  &  8:  =   9:  ?  0: 
; q: esc w:     e:  (  r:  )  t:  '  y:     u:  /  i:  \   o:     p: 
; a:  @  s:  $  d:  {  f:  }  g:     h:  <  j:  v  k:  ^   l:  >  ö: 
; z:     x:  [  c:  ]  v:  _  b:  <  n:  >  m:  |  ,:  ;   .:  :  -:  

; Number row
F14 & 1::Send '{!}'
F14 & 2::Send '{"}'
F14 & 3::Send "{#}"
F14 & 4::Send '{%}'
F14 & 7::Send '{&}'
F14 & 8::Send '{=}'
F14 & 9::Send '{?}'

; qwerty row
F14 & q::Send "{Esc}"
; F14 & w::Send 
F14 & e::Send "{(}"  
F14 & r::Send "{)}" 
F14 & t::Send "{'}"
; F14 & y::Send
F14 & u::Send "{/}"
F14 & i::Send "{\}"

; asdf row
F14 & a::Send "{@}"
F14 & s::Send "{$}" 
F14 & d::Send "{{}"  
F14 & f::Send "{}}"
F14 & h::Send "{Left}"  
F14 & j::Send "{Down}"
F14 & l::Send "{Right}"
F14 & k::Send "{Up}"

; zxcv row
F14 & x::Send "{[}"  
F14 & c::Send "{]}"
F14 & v::Send "{_}"  
F14 & b::Send "{<}"  
F14 & n::Send "{>}"
F14 & m::Send "{|}"
F14 & ,::Send "{;}"  
F14 & .::Send "{:}"

; bottom row
F14 & alt::Send "{BackSpace}" 
;F14 & space::Send "{Enter}" 
; Nome do script: cap14_ex29.ncl

begin

f = addfile("../../dados/tar.mensal.1979.1988.nc","r")

t = f->air ; O nome das dimensões da variável 
           ; "air" são time, level, lat, lon

; O "t" é a variável que foi importada do arquivo "f".
; A função checará se "latitude" é o nome de uma dimensão
; da variável "t". Caso seja verdade, retornará como 
; resultado True, caso contrário, False. O mesmo raciocínio 
; é aplicado para as demais dimensões.

check = isdim(t,(/"latitude","lon","time","nivel"/))

print(check) ; A resposta será:
             ; (0) False
             ; (1) True
             ; (2) True
             ; (3) False
end

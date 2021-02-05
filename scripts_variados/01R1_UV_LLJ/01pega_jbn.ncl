begin

f = addfile("uv.NDJF.1975.2000.nc","r")

lat = -17.5  ; Latitude de Santa Cruz.
lon = 296.94 ; Longitude de Santa Cruz.
zi  = 850    ; Nível inferior.
zf  = 700    ; Nível superior.
u   = "uwnd" ; Nome da variável u do arquivo.
v   = "vwnd" ; Nome da variável v do arquivo.

time       = f->time             ; Importa a variável time do arquivo f.
AAAAMMDDHH = cd_calendar(time,3) ; Tempo no formato AAAAMMDDHH

datai = 1975010100               ; Data inicial no formato AAAAMMDDHH.
dataf = 2000123118               ; Data final no formato AAAAMMDDHH.
istr  = ind(AAAAMMDDHH.eq.datai) ; Índices que serão utilizados 
iend  = ind(AAAAMMDDHH.eq.dataf) ; na leitura da variável.

; Se o dado for do tipo float, basta remover o "short2flt()".
u850   = f->$u$(istr:iend,{zi},{lat},{lon})
v850   = f->$v$(istr:iend,{zi},{lat},{lon})
vel850 = sqrt( (u850*u850) + (v850*v850) )

u700   = f->$u$(istr:iend,{zf},{lat},{lon})
v700   = f->$v$(istr:iend,{zf},{lat},{lon})
vel700 = sqrt( (u700*u700) + (v700*v700) )

cisa   = abs(vel850-vel700)

system("rm -f jbn.datas.txt") 

do i = istr,iend ; Loop nos índices de acordo com as datas.

; Critérios para identificar Jato de Baixos Níveis (JBN) segundo
; critério 1 de Bonner adaptado por de Marengo et al. (2004).
; 1) Velocidade em 850hPa <= 12 m/s.
; 2) Cisalhamento entre 850 e 700hPa deve ser <= que 6 m/s.
; 3) Vento meridional deve ser de norte (v<0).

   if (vel850(i).ge.12 .and. cisa(i).ge.6 .and. v850(i).lt.0) then  
      print(i+" "+AAAAMMDDHH(i))
      ; A função toint foi usado porque o dado é do tipo double, isto é,
      ; apresenta muitas casas decimais, e por isso, foi convertido para inteiro.
      ; O arquivo de saída contém na primeira coluna o índice e na segunda a data.
      write_table("jbn.datas.txt","a",[/i,toint(AAAAMMDDHH(i))/],"%i %i")
   end if

end do

end

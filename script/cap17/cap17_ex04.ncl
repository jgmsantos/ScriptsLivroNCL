; Nome do script: cap17_ex04.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r")

u = short2flt(f->uwnd)
v = short2flt(f->vwnd)

printVarSummary(u) ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
                   ; time: [1569072..1570488]
                   ; level: [1000..100]
                   ; lat: [90..-90] => latitude de norte para sul.
                   ; lon: [ 0..357.5]

printVarSummary(v) ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
                   ; time: [1569072..1570488]
                   ; level: [1000..100]
                   ; lat: [90..-90] => latitude de norte para sul.
                   ; lon: [ 0..357.5]

nt = 3   ; Número de tempos do arquivo.
nz = 12  ; Número de níveis verticais do arquivo.
ny = 72  ; Número de pontos de latitude do arquivo. 
         ; Lembrando que a latitude terá um ponto a menos do
         ; dado original que tem 73 pontos.
nx = 144 ; Número de pontos de longitude do arquivo.

; Cria uma nova variável para alocar a variável interpolada.
uN = new((/nt,nz,ny,nx/),typeof(u)) 
vN = new((/nt,nz,ny,nx/),typeof(v)) 

; Não é possível utilizar a função copy_VarCoords porque o número de pontos 
; de latitude da variável de entrada não é o mesmo da variável de saída. As 
; coordenadas serão criadas na manualmente.

; Copia apenas as duas dimensões mais a esquerda, isto é, time e level.
copy_VarCoords_2(u,uN) 
copy_VarCoords_2(v,vN)

printVarSummary(uN) ; [time | 3] x [level | 12] x [72] x [144]
printVarSummary(vN) ; [time | 3] x [level | 12] x [72] x [144]

; Criação manual das coordendas.
uN!2         = "lat"
uN!3         = "lon"
uN&lat       = fspan(-88.75,88.75,ny)
uN&lon       = u&lon
uN&lat@units = "degrees_north"
uN&lon@units = "degrees_east"

; Criação manual das coordendas.
vN!2         = "lat"
vN!3         = "lon"
vN&lat       = fspan(-88.75,88.75,ny)
vN&lon       = v&lon
vN&lat@units = "degrees_north"
vN&lon@units = "degrees_east"

; A latitude deve ser de sul para norte ("::-1").
f2foshv_Wrap(u(:,:,::-1,:),v(:,:,::-1,:),uN,vN)

printVarSummary(uN) ; [time | 3] x [level | 12] x [lat | 72] x [lon | 144]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-88.75..88.75]
                    ; lon: [1.25..358.75]

printVarSummary(vN) ; [time | 3] x [level | 12] x [lat | 72] x [lon | 144]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-88.75..88.75]
                    ; lon: [1.25..358.75]

end

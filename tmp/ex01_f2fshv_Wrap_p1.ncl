load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
load "/usr/local/ncarg/lib/ncarg/nclscripts/csm/contributed.ncl_640.ncl"
load "../contributed.ncl"

begin

f = addfile("../uwnd.vwnd.nc","r")

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
ny = 181 ; Número de pontos de latitude do arquivo. Lembrando que a latitude terá um ponto a
         ; menos do dado original que tem 73 pontos.
nx = 360 ; Número de pontos de longitude do arquivo.

; Cria uma nova variável para alocar a variável interpolada.
uN = new((/nt,nz,ny,nx/),typeof(u)) 
vN = new((/nt,nz,ny,nx/),typeof(v)) 

; Não é possível utilizar a função copy_VarCoords porque o número de pontos de latitude da 
; variável de entrada não é o mesmo da variável de saída. As coordenadas serão criadas 
; na manualmente.
copy_VarCoords_2(u,uN) ; Copia apenas as duas dimensões mais a esquerda (time e level).
copy_VarCoords_2(v,vN) ; Copia apenas as duas dimensões mais a esquerda (time e level).

printVarSummary(uN) ; [time | 3] x [level | 12] x [72] x [144]
printVarSummary(vN) ; [time | 3] x [level | 12] x [72] x [144]

; Criação manual das coordendas de latitude.
uN!2         = "lat"
uN!3         = "lon"
uN&lat       = fspan(-90.,90.,ny)
uN&lon       = fspan(0.,359.,nx)
uN&lat@units = "degrees_north"
uN&lon@units = "degrees_east"

; Criação manual das coordendas de latitude.
vN!2         = "lat"
vN!3         = "lon"
vN&lat       = fspan(-90.,90.,ny)
vN&lon       = fspan(0.,359.,nx)
vN&lat@units = "degrees_north"
vN&lon@units = "degrees_east"

; A latitude deve ser de sul para norte ("::-1").
f2fshv_Wrap(u(:,:,::-1,:),v(:,:,::-1,:),uN,vN)

printVarSummary(uN) ; [time | 3] x [level | 12] x [lat | 181] x [lon | 360]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-90..90]
                    ; lon: [ 0..359]

printVarSummary(vN) ; [time | 3] x [level | 12] x [lat | 181] x [lon | 360]
                    ; time: [1569072..1570488]
                    ; level: [1000..100]
                    ; lat: [-90..90]
                    ; lon: [ 0..359]

velo = wind_speed(u,v)
veli = wind_speed(uN,vN)

wks = gsn_open_wks("pdf","ex01_f2fshv_Wrap_p2")

plot = new(2,graphic)
  
res                      = True
res@gsnDraw              = False           ; don't draw
res@gsnFrame             = False           ; don't advance frame
res@cnFillOn             = True            ; turn on color
res@cnFillMode           = "RasterFill"   
res@lbLabelBarOn         = False           ; turn off individual cb's
res@cnLinesOn            = False
res@gsnLeftString        = ""
res@gsnRightString       = ""
res@gsnCenterString      = ""
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = ispan(1,12,1)
res@lbLabelBarOn         = False 

res@tiMainString         = "Velocidade do vento em 1000hPa - Grade original: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(0) = gsn_csm_contour_map(wks,velo(0,0,:,:),res) 

res@tiMainString        = "Velocidade do vento em 1000hPa - Grade interpolada: regular 1.0~S~o~N~ x 1.0~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,veli(0,0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)

end

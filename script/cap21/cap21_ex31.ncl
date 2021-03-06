; Nome do script: cap21_ex31.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd) 

uz = zonalAve(u) ; Realiza a média zonal (longitude). 
                 
printVarSummary(uz) 
; Dimensions and sizes: [time | 3] x [level | 12] x [lat | 73]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex31")

res                              = True
res@tiMainString                 = "M"+eacute+"dia zonal"
res@cnLevelSpacingF              = 5.0   ; Espaçamento entre 
                                         ; as isolinhas.
res@gsnContourZeroLineThicknessF = 5.0 	 ; Espessura da linha do 
                                         ; contorno zero.
res@gsnContourNegLineDashPattern = 1 	 ; Fixa as isolinhas negativas 
                                         ; com o padrão 1
                                         ; (linhas tracejadas).
res@gsnDraw                      = False ; Não cria a figura.
res@gsnFrame                     = False ; Não avança o frame.

plot = gsn_csm_pres_hgt(wks,uz(0,:,:),res)

; Personalização do padrão de preenchimento.

opt                  = True
opt@gsnShadeFillType = "pattern"  ; Pode ser "color" ou "pattern".
opt@gsnShadeLow      = 17         ; Tipo de preechimento.

plot = gsn_contour_shade(plot,0,0,opt) ; Preenche os valores menores 
                                       ; que zero.

draw(plot)
frame (wks)

end

begin

fo   = addfile("../zg_hadgem2_200501.nc","r")
zgeo1 = fo->zg

f   = addfile("../zg_hadgem2_200501.nc","r")
zgeo2 = f->zg

is_cyclic = True    ; Dado global.
guess     = 1       ; Usa média zonal.
nscan     = 1000    ; Número máximo de iterações a ser usado.
epsx      = 1.0e-2  ; Variável dependente.
relc      = 0.6     ; Coeficiente de relaxação.
opt       = 0       ; Não usado.

poisson_grid_fill(zgeo2,is_cyclic,guess,nscan,epsx,relc,opt) ; Preenchimento dos dados ausentes.

printMinMax(zgeo1,0)

wks = gsn_open_wks("pdf","ex01_poisson_grid_fill_p2")

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
res@cnLevels             = ispan(-50,400,50)
res@mpFillOn             = False

res@tiMainString         = "Dado original: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(0) = gsn_csm_contour_map(wks,zgeo1(0,0,:,:),res) 

res@tiMainString        = "Dado com preenchimento: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,zgeo2(0,0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)

end

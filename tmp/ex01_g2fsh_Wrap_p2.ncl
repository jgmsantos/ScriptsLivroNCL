begin

a    = addfile("../MCGA.1985.nc","r")
prec = a->prec

prec_interp = g2fsh_Wrap(prec(:,::-1,:),(/72,144/))

wks = gsn_open_wks("pdf","ex01_g2fsh_Wrap_p2")

gsn_define_colormap(wks,"prcp_1")

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
res@cnLevels             = ispan(2,20,2)
res@cnFillColors         = ispan(2,18,1) 

res@tiMainString         = "Grade original: gaussiana"

plot(0) = gsn_csm_contour_map(wks,prec(0,:,:),res) 

res@tiMainString        = "Grade interpolada: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,prec_interp(0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)

end

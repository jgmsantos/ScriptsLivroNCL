begin

a    = addfile("../trmm.2009.mensal.nc","r")
prec = a->r

new_lat = fspan(-49.875,49.875,72)
new_lon = fspan(-178.75,178.75,144)

prec_interp = linint2_Wrap(prec&lon,prec&lat,prec,True,new_lon,new_lat,0)

printMinMax(prec,0)
printMinMax(prec_interp,0)

printVarSummary(prec_interp)

prec_interp!1         = "lat"
prec_interp!2         = "lon"
prec_interp&lat@units = "degrees_north"
prec_interp&lon@units = "degrees_east"
   
wks = gsn_open_wks("pdf","ex01_linint2_Wrap_p2")

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
res@cnLevels             = ispan(2,30,2)
res@cnFillColors         = ispan(2,18,1) 
res@mpMinLatF            = -40.0
res@mpMaxLatF            =  40.0

res@tiMainString         = "TRMM grade original: regular 0.25~S~o~N~ x 0.25~S~o~N~"

plot(0) = gsn_csm_contour_map(wks,prec(0,:,:),res) 

res@tiMainString        = "TRMM grade interpolada: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,prec_interp(0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)

end

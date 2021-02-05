load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

f = addfile("../wrfout_d01_2010-03-15_00_00_00","r")

lat2d    = f->XLAT(0,:,:)
lon2d    = f->XLONG(0,:,:)

t2       = wrf_user_getvar(f,"T2",-1)
t2@lat2d = wrf_user_getvar(f,"XLAT",0)
t2@lon2d = wrf_user_getvar(f,"XLONG",0)

lat = fspan(-90,90,73)
lon = fspan(-178.75,178.75,144)

t2_rect = rcm2rgrid(lat2d,lon2d,t2,lat,lon,0)

t2_rect!0         = "time"
t2_rect!1         = "lat"
t2_rect!2         = "lon"
t2_rect&lat       = lat
t2_rect&lon       = lon
t2_rect&lat@units = "degrees_north"
t2_rect&lon@units = "degrees_east"

printMinMax(t2,0)

wks = gsn_open_wks("pdf","ex01_rcm2rgrid_p2")

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
res@cnLevels             = ispan(270,310,5)
res@mpFillOn             = False
res@mpMinLatF            = -20.0
res@mpMaxLatF            =  20.0
res@mpMinLonF            = -90.0
res@mpMaxLonF            = -20.0

res@tiMainString         = "WRF dado original: curvilinear 9km"

plot(0) = gsn_csm_contour_map(wks,t2(0,:,:),res) 

res@tiMainString        = "WRF dado interpolado: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,t2_rect(0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)

end

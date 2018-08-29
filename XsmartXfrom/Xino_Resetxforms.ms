 macroScript smartXform  
 category:"Xino" 
 tooltip:" Xino Smart Xform " 
 buttonText: "SXF" 
 icon:#("Xino_icon",22)
 
(

Global rx = resetxform

try (destroydialog smartxf_roll )catch()

rollout Smartxf_roll "SmartXform" width:112 height:270
(
	button SmartXf "Smart Xform" pos:[9,13] width:94 height:24 Tooltip:"Select any editable objects you want and reset their xform with out woried about the kind of objects. Hold 'Alt' for remove also any height from objects and move them to Zero in Z direction " --, 'Control' For adding XformUvw. "
	checkButton addmod_chb "Add Modifier ?" pos:[9,108] width:94 height:20 tooltip: "Automatically thick every needed edits modifiers for your selection Add them in top of all other modifiers bacause unthicking unneeded  is so faster :)"
	checkButton pivot_chb "Pivot ?" pos:[9,47] width:94 height:20 tooltip: "Move pivot to center or bottom Center of all selected objects. When perssing: Hold 'Control' for choose the bottom strightly "
	groupBox grp2 "" pos:[4,3] width:105 height:37
	groupBox grp3 "" pos:[4,98] width:105 height:113
	groupBox grp1 "" pos:[4,37] width:105 height:65
	checkbox editpoly_chb "Edit Poly" pos:[30,130] width:75 height:20
	checkbox EditSpline_chb "Edit Spline" pos:[30,150] width:75 height:20
	checkbox EditMesh_chb "Edit Mesh" pos:[30,170] width:75 height:20
	checkbox EditPatch_chb "Edit Patch" pos:[30,190] width:75 height:20
	Radiobuttons  ppivot_rdb "" labels:#("Center" , "Bottom")  pos:[30,68] 
	Button justpivot_btn ">" pos:[9,68]  width:15 height:30 tooltip:"Just Fix Pivot For selection" enabled: false 
	Button justaddmod_btn ">" pos:[9,132]  width:15 height:75 tooltip:"Just add modifiers to selection Hold 'control' if you want to convert to editable anything smartly " enabled: false 
	------polyboost_smartrotateinterigate
	groupbox rot_GP "" width:105 height: 58 offset:[-9,-5]
				
	dropdownlist degdrop "" items:#("1","5","10","20","30","45","60","90","120","180","240") selection:8 height:12 width:20 offset:[-5,-53]
	button rcw "<" height:20 width:29 offset:[16,-27] images:#((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CWm.bmp"), 1, 1, 1, 1 ,1)--tooltip: ~RCW_TOOLTIP~
	button rccw "" height:20 width:29 offset:[-14,-25] images:#((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CCWm.bmp"), 1, 1, 1, 1 ,1)  --tooltip: ~RCCW_BUTTONTEXT~
	spinner rotspin "D°"  range:[0,360,90] fieldwidth:36 scale:1 align:#center  offset:[-5,0]
	checkbutton x_rot "X" height:15 width:15 offset:[42,-46] enabled:false
	checkbutton y_rot "Y" height:15 width:15 offset:[42,-5] 	enabled:false
	checkbutton z_rot "Z" height:15 width:15 	offset:[42,-5] enabled:false
	---------------
			
	
	
	FN cpivot  = 
	
	(
		if pivot_chb.state== true then 
		
			(	
					for i in selection do 
															
					(
						centerpivot(i)
						case ppivot_rdb.state of (2: (i.pivot.z = i.min.z))
								
						
					)	
			)				
		

	)
	
	Fn applysmartxform =
				(
	
	for i in selection where superclassof i == Geometryclass or superclassof i ==shape  Do 
						
						(
							--if  rxs == 1 do rx = resetxform
							--if rxs == 0 do  rx = classof 
							
							
							case classof i  of 
							
						(
							
							
							editable_poly : 
												(	
													rx i
													
													
														if editpoly_chb.state == true then 
															(
																addmodifier i (Edit_poly())
															)
															else 
															(
																convertto i Editable_poly
															)
													
													
													
												)
												

												
							PolyMeshObject : 
												(
													rx i
													
													
													if editpoly_chb.state == true then 
															(
																addmodifier i (Edit_poly())
															)
															else 
															(
																convertto i Editable_poly
															)
												)
												
							Editable_patch : 
												(
													rx i
													
													
													if editpatch_chb.state == true then 
															(
																addmodifier i (Edit_patch())
															)
															else 
															(
																convertto i Editable_patch
															)
												)
												
							Editable_mesh : 
												(
													 rx i
													
													
													if editmesh_chb.state == true then 
															(
																addmodifier i (Edit_mesh())
															)
															else 
															(
																convertto i Editable_mesh
															)
												)
												
							NURBSSurf : 
												(
													rx i
																										
													convertto i NURBSSurf
												)
												
												
												
												
												
						)
						case superclassof i of 
						(
						shape : 			(
													
													rx i
													if EditSpline_chb.state == true then 
															(
																addmodifier i (Edit_spline())
															)
															else 
															(
																convertto i splineshape
															)
													
												)
												
						)
						--rx = resetxform
					)
				)
				
	FN Smarttick = 
	(
		For i in selection do 
		(
					case classof i of 
					(
					Editable_mesh : Editmesh_chb.state=true		
					Editable_patch : Editpatch_chb.state=true 
					Editable_poly : editpoly_chb.state = True
					PolyMeshObject : editpoly_chb.state = True
					splineshape : EditSpline_chb.state=true 
					)	
					
					case superclassof i of  
					(
						Shape :  EditSpline_chb.state=true 
					)
					
		)
	)
				
				
on smartxf open do 
	
      (
			editpoly_chb.enabled = False
			EditSpline_chb.enabled=False	
			Editpatch_chb.enabled=false 
			Editmesh_chb.enabled=false
			ppivot_rdb.enabled= false
		--	rcw.images = #((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CWm.bmp"), 1, 1, 1, 1 ,1)
			--rccw.images = #((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CCWm.bmp"), 1, 1, 1, 1 ,1)
		  
		)
	
		
		on smartxf close do
			(
				PolyBoost.PBo_transmainpos = getdialogpos PBo_transmain
				PolyBoost.TransformDialogOpen = false
			)
			/*
			on PBo_transmain open do
			(
				rcw.images = #((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CWm.bmp"), 1, 1, 1, 1 ,1)
				rccw.images = #((bitmap 29 20 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_CCWm.bmp"), 1, 1, 1, 1 ,1)
				--getsetsize.images = #((bitmap 19 17 color:([255,255,255] * (colorman.getcolor #text))), openbitmap ((GetDir #maxroot) + "stdplugs\\stdscripts\\(PolyTools)\\Images\PB_Arrowupm.bmp"), 1, 1, 1, 1 ,1)
			)
			*/
			on degdrop selected state do
			(
				rotspin.value = degdrop.selected as integer
				rotspin.value = degdrop.selected as integer
			)
			on rcw pressed do PolyBoost.SmartRotate rotspin.value
			on rccw pressed do PolyBoost.SmartRotate -rotspin.value
			on getsize pressed do PolyBoost.GetSizefunc()
	
		
on pivot_chb changed state do 
			
		(
			if keyboard.controlpressed Do 
				
			(
				ppivot_rdb.state = 2 
			)
			
			if pivot_chb.state ==true then 
			(
					ppivot_rdb.enabled= true
					justpivot_btn.enabled=true
			)
			else 
			(
					ppivot_rdb.enabled= false
					justpivot_btn.enabled=false
			)
		)
		
on justpivot_btn pressed DO  cpivot()

on justaddmod_btn pressed DO 
(
	rx = classof
	
						 if keyboard.controlpressed then
							 
						 (		Editpoly_chb.State = False
								EditSpline_chb.state=False	
								Editpatch_chb.state=false 
								Editmesh_chb.state=false
								
								--rxs = 0
								cpivot()	
								applysmartxform()
								
								
						 )
						 else 
						 (
						
													Smarttick()
													
													--rxs = 0
													cpivot()	
													applysmartxform()
						 )
						 IF keyboard.shiftpressed do 
						 (
						 For i in selection do convertto i Editable_poly
						 )
						 
							
)
	
On addmod_chb changed state DO 
	
	(
	
	if addmod_chb.state == true then 
							(
								
								editpoly_chb.enabled = true
								EditSpline_chb.enabled=true
								Editpatch_chb.enabled=true 
								Editmesh_chb.enabled=true
								justaddmod_btn.enabled=true
								Smarttick()
								
							)
							else 
							(
								editpoly_chb.enabled = False
								editpoly_chb.state = False
								EditSpline_chb.state=False 
								EditSpline_chb.enabled=False 
								Editpatch_chb.enabled=false
								Editpatch_chb.state=false
								Editmesh_chb.state=false
								Editmesh_chb.enabled=false
								justaddmod_btn.enabled=false
							)

	)
	
	
	
	
on smartxf pressed DO 
	
	( 
			rx = resetxform
			
			undo on 
				
			(
				 if keyboard.altpressed do 
					 
				 (
						 for i in selection where superclassof i == Geometryclass or superclassof i ==shape  Do 
							 
						 (   
							
							 centerpivot(i)
							 i.pivot.z = i.min.z
							 i.pos.z = 0
							 
									 if pivot_chb.state ==false DO
									 (
									 
											if  querybox   "All selection pivots moved to bottom center do you want to put pivots in center?" title:"specify pivot position "   then (centerpivot(i))
									 )						
							
						 )
					 
						 
				)
					if addmod_chb.state==true do smarttick()
					
					--rxs = 1
					Cpivot()
					applysmartxform()
				
							
				
						
						/*
						
							if keyboard.controlpressed do 
								(
									for i in selection where superclassof i == Geometryclass or superclassof i ==shape  Do 
								
											(addmodifier i (uvw_Xform()))		
								)
						*/
					
			)--end undo 

	)--end button

) --end rollout 

createdialog smartxf_roll

) ---end macro

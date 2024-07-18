function onParadeStart()

    --0Session->Animation->OpenGL animation export->
    --300×300
    --#FFFFFF
    
    sf=ldc.subfile() -- get the reference to the ldraw file which contains the parts list

    pieceCounter = 1 -- counter move through the List of pieces
    cameraLoopCounter = 1 -- move through differnt camera view loops for each piece
    frameCounter = 0 -- keep track of a frame count to Increment the camera angles for each camere loop

    myFPS = 8 -- setting frames per second to 6 so that myFPS"cameraAngleIncrement - 360
    cameraAngleIncrement = 360/myFPS -- setting to 60 so that myFPS above is 6, so that myFPS cameraAngleIncrement = 360
    
    unviewPosition=ldc.vector()
    unviewPosition:set(10000, 10000,10000) -- piece posistion when hiding from camera
    viewPosition=ldc.vector()
    viewPosition:set(25, 25, 25) -- piece posistion when viewing with camera

    -- don't forget that animation length and FPS are set in registration function
    
    --setup initial camera state
    cam=ldc.view():getCamera()
    camPos=ldc.vector()
    camPos:set(50,-50,50) -- camera posistion set to introduce variation in the viewing angle during camera rotation
    camDist = 1350 -- camera distance set to accomodate large pieces.
    cam:setThirdPerson(camPos, camDist, 0, 0, 0)
    cam:apply (0)

    -- place all pieces out of view
    refCnt=sf:getRefCount()
    for i=1,refCnt do
        sf:getRef(i):setPos(unviewPosition)
    end

    sf:getRef(1):setPos(viewPosition) -- put first piece in-place

end -- end function onParadestart()
        
function onParadeFrame()

    frameCounter = frameCounter + 1 -- counter for tracking purposes below
    cam = cam.view():getCamera()

    if cameraLoopCounter == 1 then -- rotate the camera 360 degrees around the piece on the first axis
        cam:setThirdPerson(camPos, camDist, cameraAngleIncrement*frameCounter, 0, 0)
        cam:apply(0)
        if frameCounter > myFPS then -- if finished a complete rotation of the camera, go on to the next step
            frameCounter = 0
            cameraLoopCounter = 2
        end
    else
        if cameraLoopCounter == 2 then -- rotate the camera 90 degrees around the piece on the second axis
            cam:setThirdPerson(camPos, camDist, 0, cameraAngleIncrement*frameCounter, 0)
            if frameCounter == myFPS then -- Finished complete rotation of the camera, go on to the next step
                frameCounter = 0
                cameraLoopCounter = 3
            end
        else
            if cameraLoopCounter == 3 then -- rotate the camera 30 degrees around the piece on the third axis
                cam:setThirdPerson(camPos, camDist, 0, 0, cameraAngleIncrement*frameCounter)
                cam:apply(0)
                if frameCounter == myFPS then -- if finished a rotation of the camera, go back to the first step
                    frameCounter = 0
                    cameraLoopCounter = 4
                end
            else
                if cameraLoopCounter == 4 then --rotate the camera 360 degrees around the piece on two different axes
                    cam:setThirdPerson(camPos, camDist, cameraAngleIncrement*frameCounter, cameraAngleIncrement*frameCounter)
                    cam:apply(0)
                    if frameCounter == myFPS then -- it finished a rotation of the camera, go on to the next step
                        frameCounter = 0
                        cameraLoopCounter = 5
                    end
                else
                    if cameraLoopCounter == 5 then -- rotate the camera 90 degrees around the piece on two different axes
                        cam:setThirdPerson(camPos, camDist, cameraAngleIncrement*frameCounter, cameraAngleIncrement*frameCounter, cameraAngleIncrement*frameCounter)
                        cam:apply(0)
                        if frameCounter == myFPS then -- if finished a rotation of the camera, go on to the next step
                            frameCounter = 0
                            cameraLoopCounter = 1
                            if pieceCounter == refCnt then -- if there are no more pieces, go back to the beginning
                                sf:getRef(pieceCounter):setPos(unviewPosition)
                                pieceCounter = 1
                                sf:getRef(pieceCounter):setPos(viewPosition)
                                cam:setThirdPerson(camPos, camDist, 0, 0, 0)
                                cam:apply(0)
                            else -- otherwise switch to the next piece
                                st:getRef(pieceCounter):setPos(unviewPosition)
                                pieceCounter = pieceCounter + 1
                                sf:getRef(pieceCounter):setPos(viewPosition)
                                cam:setThirdPerson(camPos, camDist, 0, 0, 0)
                                cam:apply(0)
                            end
                        end
                    end
                end
            end
        end
    end
end -- end function onParadeFrame()
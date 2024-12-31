function adaptivebox2(ax, floor3, roof3, front, leftside3, rightside3, object, object_position, object_counter)
%Blends walls that are blocking the view by analyzing current camera
%position
%Parameters: Warped Walls of the box
%Calls dispbox with parameters that blend some walls
    global aBox;
    %reset bool variable
    aBox.stopBox = false;

    %Initializaation
    z2=1.0e+03 *[ 0.1293   -2.0773    0.1162];
    %f=figure(2);
    dispboxrect(ax, 1,floor3,1,roof3,1,front,1,leftside3,1,rightside3,z2,1, object, object_position, object_counter)
    
    %create stop button
    aBox.stopButton = uicontrol('style','push',...
        'unit','pix',...
        'position',[20 420 120 30],...
        'string','Stop 3DImage');
    set(aBox.stopButton,'callback',{@stop})

    i=0;
    %pause(6)
    pause(0.2)
    roofvar=1;floorvar=1;leftvar=1;rightvar=1;frontvar=1;
    oldroofvar=roofvar;oldfloorvar=floorvar;oldleftvar=leftvar;oldrightvar=rightvar;oldfrontvar=frontvar;
    while(aBox.stopBox == false)        
        i=i+1;
        a=campos;
        
        %If z value of cameraposition is greater than 0.3 remove roof, because else
        %it would block parts of back wall
        if a(3)>0.3
            roofvar=0;floorvar=1;frontvar=1;
        end
        %If z value of cameraposition is smaller than -0.3 remove floor, because
        %else it would block parts of back wall
        if a(3)<-0.3
            roofvar=1;floorvar=0;frontvar=1;
        end
        %If x value of cameraposition is greater than 0.3 remove right wall, because else
        %it would block parts of back wall
        if a(1)>0.3
            rightvar=0;leftvar=1;frontvar=1;
        end
        %If x value of cameraposition is smaller than -0.3 remove left wall, because
        %else it would block parts of back wall
        if a(1)<-0.3
            rightvar=1;leftvar=0;frontvar=1;    
        end
        %If one of the following conditions for the x and y values of the
        %cameraposition are fulfilled, remove the back wall because it is blocking
        %a side wall
        if a(1)<17.2 && a(2)>0.15
            frontvar=0;
        end
    
        if a(1)>-17.33 && a(2)>0.15
            frontvar=0;
        end
    
        %disp(campos)
    
        %display the box again if there has been a significant change in camera position
        %detected which has to blend walls in or out
    
        b=campos;
        if oldroofvar~=roofvar || oldfloorvar~=floorvar || oldleftvar~=leftvar || oldrightvar~=rightvar || oldfrontvar~=frontvar
    
            dispboxrect(ax, floorvar,floor3,roofvar,roof3,frontvar,front,leftvar,leftside3,rightvar,rightside3,b,0,  object, object_position, object_counter)%disp(b)
        end    
        oldroofvar=roofvar;oldfloorvar=floorvar;oldleftvar=leftvar;oldrightvar=rightvar;oldfrontvar=frontvar;
        pause(0.05);
    end
    delete(aBox.stopButton)

end

function stop(varargin)
    global aBox
    aBox.stopBox = true;
end
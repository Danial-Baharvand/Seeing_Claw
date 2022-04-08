function [redTestImg,greenTestImg,selected] = findInWork(wsRedOnly,wsRedBlobs,wsGreenOnly,wsGreenBlobs,tshapesInf,shapesInf,shapeNumber)

redTestImg=wsRedOnly;
selected=[0,0,0];
%selectedIndex=1;
for i=1:length(wsRedBlobs)
    different=0;
    for j=1:3
        if tshapesInf(i)~=shapesInf(j)
            different=different+1;
        else
            selected(j)=i;
            %selectedIndex=selectedIndex+1;
        end
        if different==3
            redTestImg(wsRedBlobs(i).vmin:wsRedBlobs(i).vmax, wsRedBlobs(i).umin:wsRedBlobs(i).umax) = 0;
        end
    end
end
greenTestImg=wsGreenOnly;
for i=1:length(wsGreenBlobs)
    different=0;
    for j=1:3
        if tshapesInf(i+ shapeNumber)~=shapesInf(j)
            different=different+1;
           else
            selected(j)=i+ shapeNumber;
            %selectedIndex=selectedIndex+1;
        end
        if different==3
            greenTestImg(wsGreenBlobs(i).vmin:wsGreenBlobs(i).vmax, wsGreenBlobs(i).umin:wsGreenBlobs(i).umax) = 0;
        end
    end
end

function [orgPoints,destPoints] = findWithHom(origin,destination,worksheet)

%manual testing
% origin="small03.jpg";
% destination="small04.jpg";
% worksheet="image04.jpg";
%%
[shapes,sizes,colors,shapesInf] = smallFunc(origin);
[shapes2,sizes2,colors2,shapesInf2] = smallFunc(destination);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Reading worksheet
wsRead = imread(worksheet);

%Splitting read image into color segments
wsRedSeg = wsRead(:,:,1);
wsGreenSeg = wsRead(:,:,2);
wsBlueSeg = wsRead(:,:,3);

%Normalising each segment
wsRedNormal = double(wsRedSeg)/255;
wsGreenNormal = double(wsGreenSeg)/255;
wsBlueNormal = double(wsBlueSeg)/255;

%Adjusting each segment
wsRedNormalA = wsRedNormal.^2.5;
wsGreenNormalA = wsGreenNormal.^2.5;
wsBlueNormalA = wsBlueNormal.^2.5;

%Finding relative values for each segment
wsRedRel = wsRedNormalA./(wsRedNormalA+wsGreenNormalA+wsBlueNormalA);
wsGreenRel = wsGreenNormalA./(wsRedNormalA+wsGreenNormalA+wsBlueNormalA);
wsBlueRel = wsBlueNormalA./(wsRedNormalA+wsGreenNormalA+wsBlueNormalA);

%Showing only blue, red and green on each segment
wsRedOnly =wsRedRel>0.5;
wsGreenOnly =wsGreenRel>0.5;
wsBlueOnly =wsBlueRel>0.5;

%Opening operations have not been ustilised due to complications
%with shape recognition but is left here for future use
strelBlue = strel('square',20);
wsBlueOnly = imopen(wsBlueOnly,strelBlue);
strelRed = strel('square',8);
wsRedOnly = imopen(wsRedOnly,strelRed);
strelGreen = strel('square',6);
wsGreenOnly = imopen(wsGreenOnly,strelGreen);

%Cropping images    
wsBlueBlobs = iblobs(wsBlueOnly,'area',[2000, 800000], 'boundary');
wsRedOnly = imcrop(wsRedOnly, [min(wsBlueBlobs.umin)-15 min(wsBlueBlobs.vmin)-15 max(wsBlueBlobs.umax)-min(wsBlueBlobs.umin)+30 max(wsBlueBlobs.vmax)-min(wsBlueBlobs.vmin)+30]);
wsGreenOnly = imcrop(wsGreenOnly, [min(wsBlueBlobs.umin)-15 min(wsBlueBlobs.vmin)-15 max(wsBlueBlobs.umax)-min(wsBlueBlobs.umin)+30 max(wsBlueBlobs.vmax)-min(wsBlueBlobs.vmin)+30]);
wsBlueOnly = imcrop(wsBlueOnly, [min(wsBlueBlobs.umin)-15 min(wsBlueBlobs.vmin)-15 max(wsBlueBlobs.umax)-min(wsBlueBlobs.umin)+30 max(wsBlueBlobs.vmax)-min(wsBlueBlobs.vmin)+30]);

%Finding blue blobs
wsBlueBlobs = iblobs(wsBlueOnly,'area',[2000, 800000], 'boundary');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Finding red blobs
wsRedBlobs = iblobs(wsRedOnly,'area',[2000, 800000], 'boundary');
%Finding green blobs
wsGreenBlobs = iblobs(wsGreenOnly,'area',[2000, 800000], 'boundary');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Key:
%1st digit shape: 0 = circle    1 = triangle    2 = square
%2nd digit color: 0 = red       1 = green       2 = blue
%3rd digit size:  0 = small     1 = large
shapeNumber = 0;
tshapes = ["","",""];
tcolors = ["","",""];
tsizes = ["","",""];
tshapesInf=zeros(1,length(wsRedBlobs)+length(wsGreenBlobs));


% Left this here in case we wanted to diagnose a problem
% %Creating new drawing figure
% figure()
% 
% %Displaying only red and green shapes
% imshow( wsRedOnly);
% 
% 
% %Looping through red blobs to find triangles
% for i=1:length(wsRedBlobs)
%      %wsRedBlobs(i).plot_box('g');
%      wsRedBlobs(i).plot('r*');
%      if wsRedBlobs(i).circularity > 0.5
%         wsRedBlobs(i).plot_box('r-.')
%      end
%      text(wsRedBlobs(i).uc, wsRedBlobs(i).vc, string(i),'color','red');
% end




%Looping through red blobs and determining shape
for i=1:length(wsRedBlobs)
     if wsRedBlobs(i).circularity > 0.9
         shapeNumber = i;
         tshapes(i) = "Circle";
         tcolors(i) = "red";
         tshapesInf(i)=tshapesInf(i)+000;
     elseif wsRedBlobs(i).circularity > 0.7
         shapeNumber=i;
         tshapes(i)="Square";
         tcolors(i) = "red";
         tshapesInf(i)=tshapesInf(i)+200;
     elseif wsRedBlobs(i).circularity > 0.5
         shapeNumber=i;
         tshapes(i)="Triangle";
         tcolors(i) = "red";
         tshapesInf(i)=tshapesInf(i)+100;
     else
        fprintf('Red shape ID %d is of an unknown type123123\n', i );
     end
end

%Looping through green blobs and determining shape
for i=1:length(wsGreenBlobs)
     if wsGreenBlobs(i).circularity > 0.9
         tshapes(i+ shapeNumber)="Circle";
         tcolors(i+ shapeNumber) = "green";
         tshapesInf(i+ shapeNumber)=tshapesInf(i+ shapeNumber)+010;
     elseif wsGreenBlobs(i).circularity > 0.7
         tshapes(i+ shapeNumber)="Square";
         tcolors(i+ shapeNumber) = "green";
         tshapesInf(i+ shapeNumber)=tshapesInf(i+ shapeNumber)+210;
     elseif wsGreenBlobs(i).circularity > 0.5
         tshapes(i+ shapeNumber)="Triangle";
         tcolors(i+ shapeNumber) = "green";
         tshapesInf(i+ shapeNumber)=tshapesInf(i+ shapeNumber)+110;
     else
         fprintf('Green shape ID %d is of an unknown type\n', i+shapeNumber );
     end
end


aveArea = round(wsBlueBlobs(5).area*1.2);
%Looping through red blobs and determining size
for i=1:length(wsRedBlobs)
   if wsRedBlobs(i).area > aveArea
       shapeNumber=i;
       tsizes(i)="large";
       tshapesInf(i)=tshapesInf(i)+001;
   elseif wsRedBlobs(i).area < aveArea
       shapeNumber=i;
       tsizes(i)="little";
   end
end

%Looping through green blobs and determining size
for i=1:length(wsGreenBlobs)
   if wsGreenBlobs(i).area > aveArea
       tsizes(i+shapeNumber)="large";
       tshapesInf(i+ shapeNumber)=tshapesInf(i+ shapeNumber)+001;
   elseif wsGreenBlobs(i).area < aveArea
       tsizes(i+shapeNumber)="little";
   end
end
%testInTask=zeros(size(wsRead),'logical');
%testImg=wsGreenOnly + wsRedOnly;



[redTestImg,greenTestImg,selected] = findInWork(wsRedOnly,wsRedBlobs,wsGreenOnly,wsGreenBlobs,tshapesInf,shapesInf,shapeNumber);
[redTestImg2,greenTestImg2,selected2] = findInWork(wsRedOnly,wsRedBlobs,wsGreenOnly,wsGreenBlobs,tshapesInf,shapesInf2,shapeNumber);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Get coords of blue circle centroids
for i=1:length(wsBlueBlobs)
     Pb(1,i) = wsBlueBlobs(i).uc;
     Pb(2,i) = wsBlueBlobs(i).vc;
end
Q = [20, 560; 182.5, 560; 345, 560; 20, 290; 182.5, 290; 345, 290;20, 20; 182.5, 20;  345, 20];
H = homography(Pb, Q');

orgPoints=[ 0 0 0
            0 0 0];
destPoints=[ 0 0 0
             0 0 0];

%Finding blobs in image
testRedBlobs = iblobs(redTestImg,'area',[2000, 300000], 'boundary');
testGreenBlobs = iblobs(greenTestImg,'area',[2000, 300000], 'boundary');
testRedBlobs2 = iblobs(redTestImg2,'area',[2000, 300000], 'boundary');
testGreenBlobs2 = iblobs(greenTestImg2,'area',[2000, 300000], 'boundary');

% Find real-world coordinates of red shapes
for i=1:3
    if selected(i)<7
         p = [wsRedBlobs(selected(i)).uc wsRedBlobs(selected(i)).vc];
         q = homtrans(H,p');
         fprintf('There is a %s, %s, %s at %dmm %dmm\n', tsizes(selected(i)),tcolors(selected(i)),tshapes(selected(i)), q(1), q(2) );
         orgPoints(1,i)=q(1);
         orgPoints(2,i)=q(2);
    else
         p = [wsGreenBlobs(selected(i)-length(wsRedBlobs)).uc wsGreenBlobs(selected(i)-length(wsRedBlobs)).vc];
         q = homtrans(H,p');
         fprintf('There is a %s, %s, %s at %dmm %dmm\n', tsizes(selected(i)),tcolors(selected(i)),tshapes(selected(i)), q(1), q(2) );
         orgPoints(1,i)=q(1);
         orgPoints(2,i)=q(2);

    end
end

% Find real-world coordinates of red shapes
for i=1:3
     if selected2(i)<7
         p = [wsRedBlobs(selected2(i)).uc wsRedBlobs(selected2(i)).vc];
         q = homtrans(H,p');
         fprintf('There is a %s, %s, %s at %dmm %dmm\n', tsizes(selected2(i)),tcolors(selected2(i)),tshapes(selected2(i)), q(1), q(2) );
         destPoints(1,i)=q(1);
         destPoints(2,i)=q(2);
     else
         p = [wsGreenBlobs(selected2(i)-length(wsRedBlobs)).uc wsGreenBlobs(selected2(i)-length(wsRedBlobs)).vc];
         q = homtrans(H,p');
         fprintf('There is a %s, %s, %s at %dmm %dmm\n', tsizes(selected2(i)),tcolors(selected2(i)),tshapes(selected2(i)), q(1), q(2) );
         destPoints(1,i)=q(1);
         destPoints(2,i)=q(2);
     end
end


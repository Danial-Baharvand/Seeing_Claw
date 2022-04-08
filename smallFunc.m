function [shapeOutput,sizeOutput,colorOutput,shapesInfoOutput] = smallFunc(imgName)
%SMALLSHAPEFINDER Summary of this function goes here
%   Detailed explanation goes here

%Reading test sheet image
tsRead = imread(imgName);

%Splitting read image into color segments
tsRedSeg = tsRead(:,:,1);
tsGreenSeg = tsRead(:,:,2);
tsBlueSeg = tsRead(:,:,3);

%Normalising each segment
tsRedNormal = double(tsRedSeg)/255;
tsGreenNormal = double(tsGreenSeg)/255;
tsBlueNormal = double(tsBlueSeg)/255;

%Gamma correcting each segment
tsRedNormalA = tsRedNormal.^2.5;
tsGreenNormalA = tsGreenNormal.^2.5;
tsBlueNormalA = tsBlueNormal.^2.5;

%Finding relative values for each segment
tsRedRel = tsRedNormalA./(tsRedNormalA+tsGreenNormalA+tsBlueNormalA);
tsGreenRel = tsGreenNormalA./(tsRedNormalA+tsGreenNormalA+tsBlueNormalA);

%Showing only blue, red and green on each segment
tsRedOnly = tsRedRel>0.5;
tsGreenOnly = tsGreenRel>0.5;

%Strelling image
ser = strel('square',12);
tsRedOnly = imopen(tsRedOnly,ser);
seg = strel('square',10);
tsGreenOnly = imopen(tsGreenOnly,seg);

%Finding blobs in image
tsRedBlobs = iblobs(tsRedOnly,'area',[2000, 300000], 'boundary');
tsGreenBlobs = iblobs(tsGreenOnly,'area',[2000, 500000], 'boundary');

% %Looping through red blobs and marking them
% for i=1:length(tsRedBlobs)
%      tsRedBlobs(i).plot_box('r');
%      tsRedBlobs(i).plot('r*');
%      text(tsRedBlobs(i).uc, tsRedBlobs(i).vc, string(i),'color','red');
% end
% 
% %Looping through green blobs and marking them
% for i=1:length(tsGreenBlobs)
%      tsGreenBlobs(i).plot_box('g');
%      tsGreenBlobs(i).plot('g*');
%      text(tsGreenBlobs(i).uc, tsGreenBlobs(i).vc, string(i),'color','green');
% end

%Key:
%1st digit shape: 0 = circle    1 = triangle    2 = square
%2nd digit color: 0 = red       1 = green       2 = blue
%3rd digit size:  0 = small     1 = large
shapeNumber = 0;
shapes = ["","",""];
colors = ["","",""];
sizes = ["","",""];
shapesInf=[0,0,0];
cents=[tsRedBlobs.uc tsGreenBlobs.uc];

%Looping through red blobs and determining shape
for i=1:length(tsRedBlobs)
     shapeNumber=findOrder(tsRedBlobs(i),cents);
     if tsRedBlobs(i).circularity > 0.9
         shapes(shapeNumber) = "Circle";
         colors(shapeNumber) = "red";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+000;
     elseif tsRedBlobs(i).circularity > 0.7
         shapes(shapeNumber)="Square";
         colors(shapeNumber) = "red";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+200;
     elseif tsRedBlobs(i).circularity > 0.5
         shapes(shapeNumber)="Triangle";
         colors(shapeNumber) = "red";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+100;
     else
        fprintf('Red shape ID %d is of an unknown type\n', i );
     end
end

%Looping through green blobs and determining shape
for i=1:length(tsGreenBlobs)
    shapeNumber=findOrder(tsGreenBlobs(i),cents);
     if tsGreenBlobs(i).circularity > 0.9
         shapes(shapeNumber)="Circle";
         colors(shapeNumber) = "green";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+010;
     elseif tsGreenBlobs(i).circularity > 0.7
         shapes(shapeNumber)="Square";
         colors(shapeNumber) = "green";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+210;
     elseif tsGreenBlobs(i).circularity > 0.5
         shapes(shapeNumber)="Triangle";
         colors(shapeNumber) = "green";
         shapesInf(shapeNumber)=shapesInf(shapeNumber)+110;
     else
         fprintf('Green shape ID %d is of an unknown type\n', i+shapeNumber );
     end
end

for i=1:length(tsRedBlobs)
    shapeNumber=findOrder(tsRedBlobs(i),cents);
    areaR(i) = findD(tsRedBlobs(i).area,shapes(shapeNumber));
end

for i=1:length(tsGreenBlobs)
    shapeNumber=findOrder(tsGreenBlobs(i),cents);
    areaG(i) = findD(tsGreenBlobs(i).area,shapes(shapeNumber));
end

areaA = horzcat(areaG, areaR);

minArea = min(areaA);

maxArea = max(areaA);

aveArea = round((minArea + maxArea)/2)*0.92;

%Looping through red blobs and determining size
for i=1:length(tsRedBlobs)
    shapeNumber=findOrder(tsRedBlobs(i),cents);
   if findD(tsRedBlobs(i).area,shapes(i)) > aveArea
       sizes(shapeNumber)="large";
       shapesInf(shapeNumber)=shapesInf(shapeNumber)+001;
   elseif findD(tsRedBlobs(i).area,shapes(i)) < aveArea
       sizes(shapeNumber)="little";
   end
end

%Looping through green blobs and determining size
for i=1:length(tsGreenBlobs)
    shapeNumber=findOrder(tsGreenBlobs(i),cents);
   if findD(tsGreenBlobs(i).area,shapes( shapeNumber)) > aveArea
       sizes(shapeNumber)="large";
       shapesInf(shapeNumber)=shapesInf(shapeNumber)+001;
   elseif findD(tsGreenBlobs(i).area,shapes( shapeNumber)) < aveArea
       sizes(shapeNumber)="little";
   end
end

% for i=1:3
%     fprintf('There is a %s, %s, %s \n', sizes(i),colors(i),shapes(i) );
% end

shapeOutput = shapes;
sizeOutput = sizes;
colorOutput = colors;
shapesInfoOutput = shapesInf;
end


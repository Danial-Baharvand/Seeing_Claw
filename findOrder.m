function shapeNumber= findOrder (blob, cents)
if blob.uc==max(cents)
   shapeNumber=3;
elseif blob.uc==min(cents)
   shapeNumber=1;
else
   shapeNumber=2;
end
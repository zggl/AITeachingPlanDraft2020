x = imread('geeks.jpg');

% decision threshold.
% change this to a smaller value, if too many false detections occur.
% change it to a larger value, if faces are not recognized.
% a reasonable range is -10 ... 10.
threshold = 0; 

imagesc(x); hold on; colormap gray;
s = fdmex(x', threshold);
        
for i=1:size(s,1)
	h = rectangle('Position',[s(i,1)-s(i,3)/2,s(i,2)-s(i,3)/2,s(i,3),s(i,3)], ...
      'EdgeColor', [1,0,0], 'linewidth', 2);
end    
    
axis equal; 
axis off

%% import image
clear;
clc;

[file,path] = uigetfile('*.jpg',"*.png");
if isequal(file,0)
    error(' Load Error: No files selected! Load cancelled.')
else
end

fullFileName = fullfile(path, file);

obj = imread(fullFileName);
imshow(obj)

%% Segment image

% Divide image into RGB
red = obj(:,:,1);
green = obj(:,:,2);
blue = obj(:,:,3);

figure(1)
subplot(2,2,1); imshow(obj); title('Orginal image');
subplot(2,2,2); imshow(red); title('Red Plane');
subplot(2,2,3); imshow(green); title('Green Plane');
subplot(2,2,4); imshow(blue); title('Blue Plane');

% Threshold blue plane
figure(2)
level = 0.01;
bw2 = imbinarize(blue,"global");
subplot(2,2,1);  imshow(bw2); title("Blue Plane Thresholded")

%% Remove Noise

% Fill any holes
fill = imfill(bw2, "holes");
subplot(2,2,2);  imshow(fill); title("Holes Filled")

% Remove any blobs on the border of image
clear = imclearborder(fill);
subplot(2,2,3);  imshow(clear); title("Remove blobs")

% Remove any blobs that are smaller than 7 pixels across
se = strel('disk',20);
open = imopen(clear,se);
subplot(2,2,4);  imshow(open); title("Remove small blobs")

%% Measure Diamter
diameter_vector = [regionprops(open,'MajorAxisLength').MajorAxisLength];
diameter = max(diameter_vector)


% show result
figure(3)
imshow(obj)
d = imdistline;

%% export
fid = fopen('outputData.txt','wt');
fprintf(fid,'%f\n',diameter);
fclose(fid);
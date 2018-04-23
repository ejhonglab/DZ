global trial_duration
global Fr

%%%%%%%%%heatMap%%%%%%%%%%%%%%%%%%%
%slices=482;
resolution=224;
Fr=5.5;
trials=3;
%trial_duration =slices/trials;

%dFRowStack=zeros(slices/trials,resolution);
finalImage=zeros(resolution,resolution);
imagefiles=dir('*tif');
%slices=(numel(imagefiles)-2)/2;
slices=(numel(imagefiles)-1);
trial_duration =floor(slices/trials);
%trial_duration =slices/trials;
dFRowStack=zeros(trial_duration,resolution);
%dFRowStack=zeros(slices/trials,resolution);
for k=1:resolution
   
    for i=1:slices/trials                %Take only first trial of recording
    filename=imagefiles(i).name;
    image=imread(filename);

    imageRow=image(k,:);            %Take kth row of image
    imageRowStack(i,:)=imageRow;     %imageRowStack contains the pixel intensities of the first row of each slice. Columns of imageRowStack represent pixel intensities of 1 pixel in the first row over time
    end
    imageRowStack=im2double(imageRowStack);          %convert imageRowStack to double precision for deltaF_calc_function to work
    
        for j=1:resolution
            dFRowStack(:,j)=deltaF_calc_function(imageRowStack(:,j));       %iterate through each column of imageRowStack (ie the time series of each pixel in row k) and convert it from raw F to dF/F                                                                     
        end
StimOn=Fr*10;
StimOff=ceil(Fr*13);

%peakdFRowStack=dFRowStack((27:31),:);
peakdFRowStack=dFRowStack((65:68),:);
%peakdFRowStack=dFRowStack((StimOn+2:StimOff),:);

peakdFRowStackAvg=mean(peakdFRowStack);
finalImage(k,:)=peakdFRowStackAvg; 

k
end

%finalImage=flipud(finalImage);

%%%%%%%%%%gaussian filter%%%%%%%%%%%%%%%%%%%%%%
sigma = 1;        %with sigma=1, sz = 6.2
sz = 2*ceil(2.6 * sigma) + 1; 
mask = fspecial('gauss', sz, sigma);
newImage = conv2(finalImage, mask, 'same');

%%%%%%%plot figure%%%%%%%%%%%%%%%%%%%%%
figure;
clims=[-0.25 0.25];           %set colormap limits
imagesc(newImage,clims)
colormap hot
colorbar
%HeatMap(finalImage)



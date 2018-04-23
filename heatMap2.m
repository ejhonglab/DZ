global trial_duration
global Fr

%%%%%%%%%heatMap%%%%%%%%%%%%%%%%%%%
%slices=495;
resolution=224;
Fr=5.5;
trials=3;
t1=65;
t2=68;


finalImage=zeros(resolution,resolution);
imagefiles=dir('*tif');
%slices=(numel(imagefiles)-2)/2;
slices=numel(imagefiles)-1;
trial_duration =floor(slices/trials);

firstFileName=imagefiles(1).name;
firstFile=imread(firstFileName);
timeSeriesMatrix=firstFile;
   
    for i=2:trial_duration                %Take only first trial of recording
    filename=imagefiles(i).name;
    image=imread(filename);
    timeSeriesMatrix(:,:,i)=image;            
    end
    clear image                                   %clear image after first for loop 
    timeSeriesMatrix=im2double(timeSeriesMatrix); %convert imageRowStack to double precision for deltaF_calc_function to work
    
        for j=1:resolution
            for k =1:resolution
                pixelTimeSeries=timeSeriesMatrix(j,k,:); %Extract time series of each pixel (third dimension of timeSeriesMatrix)
                transposed=zeros(trial_duration,1);      %deltaF_calc_function required input to be column vector, so have to transpose pixelTimeSeries into a column vector
                transposed(:,1)=pixelTimeSeries;
                
                dFTimeSeries=deltaF_calc_function(transposed);  %calculate deltaF/F for each individual pixel 
                dFTimeSeries=dFTimeSeries(t1:t2);        
                dFPeak=mean(dFTimeSeries);              %Extract from the pixel dF/F time series only the time points for the peak response
               
                finalImage(j,k)=dFPeak;                                                    
            end
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
%saveas(newImage,


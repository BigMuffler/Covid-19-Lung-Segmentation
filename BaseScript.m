addpath('./ENSC478_2020_ProjectTestSet');
addpath('./Assets');
addpath('./Results');
clear;
clc;

photo_dir = "ENSC478_2020_ProjectTestSet/";
files = dir(photo_dir+"*.jpg");
images = cell(length(files),1);
for i=1:length(files)
    images{i} = imread( photo_dir+files(i).name );
end
PercentageofLungAffected = zeros(12,1); %matrix for storing percentage of lung infected numbers

%% New Section
for i = 1 : 12    
name = ['Results/Patient' num2str(i)];
mkdir(name);    
    
I1 = RGB2Gray(images{i});
figure();
imshow(I1);
title('OriginalImage');
AdjustedImage = Crop(I1);
AdjustedImage = AdjustedImage(~cellfun('isempty',AdjustedImage));
LeftLung = imadjust(AdjustedImage{1});
RightLung = imadjust(AdjustedImage{2});
figure();
imshowpair(LeftLung,RightLung,'montage'); %separate the intensities so its easier for the segmentation
title('AdjustedImage');

%% Otsu's Method and Segmentation of Lungs
newIML = LungSegment(LeftLung);
newIMR = LungSegment(RightLung);
figure();
imshowpair(newIML{1},newIMR{1},'montage');
title('Segmented Lungs')
%% Otsu's Method for Segmenting GGO
GGOSegmentedL = GroundGlassSegment(newIML{1});
GGOSegmentedR = GroundGlassSegment(newIMR{1});
%% Segment the actual ground glass opacity
GGOSegmentL = bwareaopen(GGOSegmentedL{1}, 100); %removes objects containing fewer than 100 pixels
GGOSegmentR = bwareaopen(GGOSegmentedR{1}, 100);
figure();
imshowpair(GGOSegmentL,GGOSegmentR,'montage');
title('Segmented GGO')

%%
ExtractedGGOL = ExtractGroundGlass(GGOSegmentL); %a function for fine tuning and find groudn glass opacity
ExtractedGGOR = ExtractGroundGlass(GGOSegmentR);
figure();
imshowpair(ExtractedGGOL,ExtractedGGOR,'montage');
title('Final GGO BW')


%% percentage of total lung
newIML{1}(newIML{1} < 0) = 0;
newIMR{1}(newIMR{1} < 0) = 0;
NumberofNonZeroPixels =  nnz(newIML{4}) + nnz(newIMR{4});
NumberofGGOPixels = nnz(ExtractedGGOL) + nnz(ExtractedGGOR);

PercentageofLungAffected(i) = NumberofGGOPixels/NumberofNonZeroPixels * 100;

%save images into files
imwrite(I1,fullfile(name,'OriginalImage.png'));
imwrite(LeftLung,fullfile(name,'LeftLung.png'));
imwrite(RightLung,fullfile(name,'RightLung.png'));
imwrite(newIML{2},fullfile(name,'LeftBinary.png'));
imwrite(newIML{3},fullfile(name,'LeftBinaryCompFull.png'));
imwrite(newIMR{2},fullfile(name,'RightBinary.png'));
imwrite(newIMR{3},fullfile(name,'RightBinaryCompFull.png'));
imwrite(newIML{1},fullfile(name,'LeftLungOnly.png'));
imwrite(newIMR{1},fullfile(name,'RightLungOnly.png'));
imwrite(GGOSegmentedL{2},fullfile(name,'OtsuLeftRGB.png'));
imwrite(GGOSegmentedR{2},fullfile(name,'OtsuRightRGB.png'));
imwrite(GGOSegmentL,fullfile(name,'GGOLeftLung.png'));
imwrite(GGOSegmentR,fullfile(name,'GGORightLung.png'));
imwrite(ExtractedGGOL,fullfile(name,'FullLeftGGO.png'));
imwrite(ExtractedGGOR,fullfile(name,'FullRightGGO.png'));




close all;
end
%% Show Results
PercentageofLungAffected

NoInfection = find(PercentageofLungAffected < 1)
ModerateInfection = find(PercentageofLungAffected<10 & PercentageofLungAffected > 1)
SevereInfection = find(PercentageofLungAffected>10)









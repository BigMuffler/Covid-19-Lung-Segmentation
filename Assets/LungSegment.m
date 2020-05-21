function LungSegment = LungSegment(mat)
    %% Otsu's Method and Segmentation of Lungs
    level = graythresh(mat); %creates threshold
    BinaryImage1 = imbinarize(mat,level); %binarizes images for segmentation
    figure();
    imshowpair(mat,BinaryImage1,'montage');
    title('Original vs Binary Image')
    %% Find Complement of Otsu's Output to Segment Lungs Fully
    BinaryComp = imcomplement(BinaryImage1); %take complement of segmented binary image (so lungs would have pixel value of 1 instead of 0)
    BinaryCompFull = imfill(BinaryComp,'holes'); %fill the holes after complement is taken (little white holes)
    figure();
    imshow(BinaryCompFull);
    title('Full Complement Binary Image of Lungs')
    newIM = BinaryCompFull.*mat; %multiply old image by new image BW2 to extract lungs only 
    
    %% extract the bright parts of the image
    Lungs = newIM - BinaryImage1; 
    LungSegment = {Lungs;BinaryImage1;BinaryCompFull;newIM};
end
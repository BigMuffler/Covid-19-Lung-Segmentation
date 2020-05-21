function GroundGlassSegment = GroundGlassSegment(mat)

    thresh = multithresh(mat,2); %Theshold on 2 levels using Otsu's method again
    seg_I = imquantize(mat,thresh); %Convert image to a 3 level segmented image 
    RGB = label2rgb(seg_I);
    figure();
    imshow(RGB);
    title('RGB Segmented Image')
    seg_I(seg_I <= 1) = 0; %Select 3rd level of segmentation
    seg_I(seg_I == 2) = 0; 
    seg_I(seg_I ~= 0) = 1;
    N = seg_I.*mat;

    N = im2uint8(N); %filter pixels larger than 90 and less than 50
    N(N>90) = 0;
    N(N<50) = 0;

    Segmented = imfill(N,'holes'); %fill holes
    
    GroundGlassSegment = {Segmented;RGB};
    
end
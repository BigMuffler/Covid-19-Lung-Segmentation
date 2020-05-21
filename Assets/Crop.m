function Crop = Crop(mat) 
    %Crop Each Lung Individually
    Bin = imbinarize(mat);
    BinC = imcomplement(Bin);
    C=~imfill(Bin,'holes');
    [Label, Total] = bwlabel(BinC,8);
    bb=regionprops(Label,'BoundingBox');
    area = regionprops(Label, 'Area');
    Img = {};
    for i=1:Total
        if area(i).Area > 20000 && area(i).Area<80000
            Img{i}=imcrop(mat,bb(i).BoundingBox);
            %Name=strcat('LungSegmented',num2str(i));
            %figure,imshow(Img{i}); title(Name);
        end
    end
   Crop = Img; 
end
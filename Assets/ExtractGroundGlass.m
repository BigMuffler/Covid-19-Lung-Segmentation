function ExtractGroundGlass = ExtractGroundGlass(mat)
    %% Segment the actual ground glass opacity
    mat = bwareaopen(mat, 100); %removes objects containing fewer than 100 pixels

%%
    props = regionprops(mat, 'Solidity', 'Area', 'perimeter');
    binaryImage2 = ~bwpropfilt(mat, 'Solidity', [0.1, inf]);
    binaryImage3 = bwpropfilt(binaryImage2, 'Area', [250, inf]);

    RealGGO = imcomplement(binaryImage3);
    ExtractGroundGlass = RealGGO;


end
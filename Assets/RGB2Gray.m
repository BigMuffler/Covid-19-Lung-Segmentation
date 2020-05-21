function RGB2Gray = RGB2Gray(selfie)

    selfie = mat2gray(selfie); %convert to double for calculations as to not lose solutions
    average = mean(selfie,3); %average color channels

    RGB2Gray = average;
end
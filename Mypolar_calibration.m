function [s0, s1, s2, S0] = Mypolar_calibration(I0,I45,I90,I135)

    % Normalization
    [I0,minI0,widthI0]=mynorm(I0);
    [I45,minI45,widthI45]=mynorm(I45);
    [I90,minI90,widthI90]=mynorm(I90);
    [I135,minI135,widthI135]=mynorm(I135);
    
    % Calculate Stokes parameters
    s1 = I0 - I90;
    s2 = (I45 - I135);
    s0 = ( I0 + I90 + I45 + I135 ) / 2;

    % Denormalization
    [I0]=destoreI(I0,widthI0,minI0);
    [I45]=destoreI(I45,widthI45,minI45);
    [I90]=destoreI(I90,widthI90,minI90);
    [I135]=destoreI(I135,widthI135,minI135);
   
    S0 = ( I0 + I90 + I45 + I135 ) / 2;%强度S0
    
end

% Normalize the image
function [I,minI,widthI]=mynorm(I)
    maxI = max(max(I));
    minI = min(min(I));
    widthI = maxI - minI;
    I = (I - minI)/widthI;
end
% Denormalize the image
function [I]=destoreI(I,widthI,minI)
I = I*widthI + minI;
end


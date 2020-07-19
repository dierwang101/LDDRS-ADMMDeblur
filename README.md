# Full-Time Monocular Road Detection Using Zero-Distribution Prior of Angle of Polarization. ECCV2020

## We offer two ways to download the database and the codes.
- baidu(https://pan.baidu.com/s/10dMZRRW5q710RbVxisd4eA     Extraction code: 2113 )
- google(https://drive.google.com/file/d/14tUFxFUJt2nut7xx9zJ8yQ83K8qGO9rg/view?usp=sharing)

## Content Description
- Folders:
	- "RAW" folder : Original LWIR DoFP images of road scene with 512×640 resolution in 14 bits.
	- "label" folder : Corresponding label of road region of 2,113 images. 1 represents road and 0 represents background.
	- "labelviz" folder : The visualization of the labeled road and background regions on S0 image.
	- "S0" folder : Corresponding intensity image after denoising and HDR correction.
- Code:
	- demo.m : A demo code for basic pre-processing of DoFP image, including denoising, demosaicking and calculating Stokes parameters.
	- BM3D : Denoising the raw DoFP image.
	- FFC_Polynomial_interpolation.m : A demosaicking algorithm [1] for recovering four high resolution polarization image from an input DoFP image.	
	- IRHDRv1.m : HDR correction of the S0 image.
- Note:
	- The polarization transmission direction of each pixel of DoFP image is arranged as in "Pixel arrangement of DoFP image.jpg".
	- Since our LWIR DoFP camera is based on the uncooled technique, an optical shutter is used for online recalibration purposes to compensate for disturbing influences derived from changing ambient conditions (sensor temperature stabilization is also used). So it needs to subtract the pixel response when the shutter is closed from the pixel response when the shutter is open, which may leads to negative pixel values. To avoid this, a fixed positive value is added to make the output always be positive and in a reasonable range. Therefore, we cannot obtain the absolute value of DoP but a relative value of DoP, while the calculation of true AoP is not affected. However, we can still use it for quantitative analysis of the DoP characteristics of the objects.

[1] Li, N., Zhao, Y., Pan, Q., Kong, S.G.: Demosaicking DoFP images using Newton's polynomial interpolation and polarization difference model. Optics Express 27(2), 1376–1391 (2019)



## If you have any question, please contact ：ln_neo@mail.nwpu.edu.cn

# Plotpeak
This application can convert all the raw files (such as .xye) in a folder into separate profile images with peak value of d-spacing and/or 2-theta in just one click. Additionally, it also plot all profiles on the same graph to ease comparison. It offers a solution to the common problems encountered in scientific research while plotting XRD profiles, such as errors due to the presence of headers in the raw files provided by instruments and inconsistencies between the wavelength of the original X-ray (such as synchrotron or other light sources) and the in-house X-ray wavelength (Copper K-α), necessitating conversion. Furthermore, the code can also be utilized to plot other spectra, such as Raman, FTIR and so on.

# Instructions
1. Download and run "Plotpeak_v6_Installer_web.exe", it will install the MATLAB Runtime.
2. Download "Plotpeak_v6.exe" (alternativily copy/cut from where you install in step 1) and put it into the .xye file folder.
3. Run the application and adjust the parameters.
4. After red "Processing" become green "Finished", the .csv files with converted wavelength and .png files for each profile would be saved in the same folder with an additional All_profiles image.
5. Check the results and adjust the parameters again (especially d & h).

# How to Cite
Chen, T. Y. (2023). Plotpeak. In (Version 6.1) GitHub. https://github.com/tarranchen/Plotpeak

# Known Issues
Perhaps due to the program reads and writes files, Windows Defender will recognize it as Trojan:Script/Wacatac.H!ml. 
You can temporarily turn off Windows Defender before running the application, or add the application to its whitelist.
If you have Matlab, you can download "Plotpeak_v6.mlappinstall" or "Plotpeak_v6.mlapp" to run with Matlab.

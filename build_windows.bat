cd build_msvc
py -3 msvc-autogen.py
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /t:build
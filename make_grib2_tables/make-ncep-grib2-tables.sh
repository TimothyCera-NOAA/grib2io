#!/bin/sh

# ---------------------------------------------------------------------------------------- 
# Originating Centers
# ---------------------------------------------------------------------------------------- 
echo " -- Making originating_centers.py"
./get-ncep-grib2-originating-centers.py > originating_centers.py

# ---------------------------------------------------------------------------------------- 
# Generate Section 0
# ---------------------------------------------------------------------------------------- 
echo " -- Making section0.py"
if [ -f section0.py ]; then rm -f section0.py; fi
for table in 0.0
do
   echo "\t - Table $table"
   ./get-ncep-grib2-table.py $table > section0.py
done

# ---------------------------------------------------------------------------------------- 
# Generate Section 1
# ---------------------------------------------------------------------------------------- 
echo " -- Making section1.py"
if [ -f section1.py ]; then rm -f section1.py; fi
for table in 1.0 1.1 1.2 1.3 1.4 1.5 1.6
do
   echo "\t - Table $table"
   ./get-ncep-grib2-table.py $table >> section1.py
done

# ---------------------------------------------------------------------------------------- 
# Generate Section 3
# ---------------------------------------------------------------------------------------- 
echo " -- Making section3.py"
if [ -f section3.py ]; then rm -f section3.py; fi
for table in 3.1 3.2
do
   echo "\t - Table $table"
   ./get-ncep-grib2-table.py $table >> section3.py
done

# Store the Earth params table here.  This is custom to grib2io.
echo "\t - Earth params table"
cat << EOF >> section3.py
earth_params = {
'0':{'shape':'spherical','radius':6367470.0},
'1':{'shape':'spherical','radius':None},
'2':{'shape':'oblateSpheriod','major_axis':6378160.0,'minor_axis':6356775.0,'flattening':1.0/297.0},
'3':{'shape':'oblateSpheriod','major_axis':None,'minor_axis':None,'flattening':None},
'4':{'shape':'oblateSpheriod','major_axis':6378137.0,'minor_axis':6356752.314,'flattening':1.0/298.257222101},
'5':{'shape':'oblateSpheriod','major_axis':6378137.0,'minor_axis':6356752.3142,'flattening':1.0/298.257223563},
'6':{'shape':'spherical','radius':6371229.0},
'7':{'shape':'oblateSpheriod','major_axis':None,'minor_axis':None,'flattening':None},
'8':{'shape':'spherical','radius':6371200.0},
}
for i in range(9,256):
    earth_params[str(i)] = {'shape':'unknown','radius':None}
EOF

# ---------------------------------------------------------------------------------------- 
# Generate Section 4 Tables for parameter categories and parameter tables unique for each
# discipline.
# ---------------------------------------------------------------------------------------- 
echo " -- Making section4.py"
if [ -f section4.py ]; then rm -f section4.py; fi
echo "\t - Parameter category tables"
./get-ncep-grib2-sect4-category-table.py > section4.py
for table in 4.3 4.4 4.5 4.6 4.7 4.8 4.9 4.10 4.11
do
   echo "\t - Table $table"
   ./get-ncep-grib2-table.py $table >> section4.py
done

# Discipline 0
echo " -- Making section4_discipline0.py"
if [ -f section4_discipline0.py ]; then rm -f section4_discipline0.py; fi
for table in $(seq 0 7 && seq 13 20 && seq 190 192)
do
   ./get-ncep-grib2-sect4-parameters-table.py 0 $table >> section4_discipline0.py
done

# Discipline 1
echo " -- Making section4_discipline1.py"
if [ -f section4_discipline1.py ]; then rm -f section4_discipline1.py; fi
for table in $(seq 0 2)
do
   ./get-ncep-grib2-sect4-parameters-table.py 1 $table >> section4_discipline1.py
done

# Discipline 2
echo " -- Making section4_discipline2.py"
if [ -f section4_discipline2.py ]; then rm -f section4_discipline2.py; fi
for table in 0 1 3 4 5
do
   ./get-ncep-grib2-sect4-parameters-table.py 2 $table >> section4_discipline2.py
done

# Discipline 3
echo " -- Making section4_discipline3.py"
if [ -f section4_discipline3.py ]; then rm -f section4_discipline3.py; fi
for table in 0 1 2 3 4 5 6 192
do
   ./get-ncep-grib2-sect4-parameters-table.py 3 $table >> section4_discipline3.py
done

# Discipline 4
echo " -- Making section4_discipline4.py"
if [ -f section4_discipline4.py ]; then rm -f section4_discipline4.py; fi
for table in $(seq 0 9)
do
   ./get-ncep-grib2-sect4-parameters-table.py 4 $table >> section4_discipline4.py
done

# Discipline 10
echo " -- Making section4_discipline10.py"
if [ -f section4_discipline10.py ]; then rm -f section4_discipline10.py; fi
for table in 0 1 2 3 4 191
do
   ./get-ncep-grib2-sect4-parameters-table.py 10 $table >> section4_discipline10.py
done

# ---------------------------------------------------------------------------------------- 
# Generate Section 5
# ---------------------------------------------------------------------------------------- 
echo " -- Making section5.py"
if [ -f section5.py ]; then rm -f section5.py; fi
for table in 5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.40
do
   echo "\t - Table $table"
   ./get-ncep-grib2-table.py $table >> section5.py
done
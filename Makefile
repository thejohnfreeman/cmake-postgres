build_dir := .build

all : configure
	cmake --build ${build_dir}
	${build_dir}/main

configure : clean
	cmake -B ${build_dir} .

clean :
	rm -rf ${build_dir}

; ModuleID = 'C:\Users\quincywu\AppData\Local\Temp\9575bb2c-3233-4286-bd61-02a508dbe78d.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f80:128:128-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-f80:128:128-n8:16:32:64"
target triple = "igil_64_GEN9"

%struct.ref_point = type { %struct.point, float }
%struct.point = type { <2 x float>, i32 }

@.str = private addrspace(2) unnamed_addr constant [39 x i8] c"This is dist=%f, a=%2v2hlf, b=%2v2hlf\0A\00", align 1
@.str1 = private addrspace(2) unnamed_addr constant [36 x i8] c"test_point_data_location = %2v2hlf\0A\00", align 1

define float @my_dist(<2 x float> %pointA, <2 x float> %pointB) {
  %1 = alloca <2 x float>, align 8
  %2 = alloca <2 x float>, align 8
  store <2 x float> %pointA, <2 x float>* %1, align 8
  store <2 x float> %pointB, <2 x float>* %2, align 8
  %3 = load <2 x float>* %1, align 8
  %4 = extractelement <2 x float> %3, i32 0
  %5 = load <2 x float>* %2, align 8
  %6 = extractelement <2 x float> %5, i32 0
  %7 = fsub float %4, %6
  %8 = load <2 x float>* %1, align 8
  %9 = extractelement <2 x float> %8, i32 0
  %10 = load <2 x float>* %2, align 8
  %11 = extractelement <2 x float> %10, i32 0
  %12 = fsub float %9, %11
  %13 = fmul float %7, %12
  %14 = load <2 x float>* %1, align 8
  %15 = extractelement <2 x float> %14, i32 1
  %16 = load <2 x float>* %2, align 8
  %17 = extractelement <2 x float> %16, i32 1
  %18 = fsub float %15, %17
  %19 = load <2 x float>* %1, align 8
  %20 = extractelement <2 x float> %19, i32 1
  %21 = load <2 x float>* %2, align 8
  %22 = extractelement <2 x float> %21, i32 1
  %23 = fsub float %20, %22
  %24 = fmul float %18, %23
  %25 = fadd float %13, %24
  %26 = call float @_Z4sqrtf(float %25)
  ret float %26
}

declare float @_Z4sqrtf(float)

define void @calc_distance(%struct.ref_point* %refpoints, %struct.point* %pointB) {
  %1 = getelementptr inbounds %struct.ref_point* %refpoints, i32 0, i32 0
  %2 = getelementptr inbounds %struct.point* %1, i32 0, i32 0
  %3 = load <2 x float>* %2, align 8
  %4 = getelementptr inbounds %struct.point* %pointB, i32 0, i32 0
  %5 = load <2 x float>* %4, align 8
  %6 = call float @my_dist(<2 x float> %3, <2 x float> %5)
  %7 = getelementptr inbounds %struct.ref_point* %refpoints, i32 0, i32 1
  store float %6, float* %7, align 4
  %8 = getelementptr inbounds %struct.ref_point* %refpoints, i32 0, i32 1
  %9 = load float* %8, align 4
  %10 = getelementptr inbounds %struct.ref_point* %refpoints, i32 0, i32 0
  %11 = getelementptr inbounds %struct.point* %10, i32 0, i32 0
  %12 = load <2 x float>* %11, align 8
  %13 = getelementptr inbounds %struct.point* %pointB, i32 0, i32 0
  %14 = load <2 x float>* %13, align 8
  %15 = call i32 (i8 addrspace(2)*, ...)* @printf(i8 addrspace(2)* getelementptr inbounds ([39 x i8] addrspace(2)* @.str, i32 0, i32 0), float %9, <2 x float> %12, <2 x float> %14)
  ret void
}

declare i32 @printf(i8 addrspace(2)*, ...)

define void @knn_kernel(%struct.ref_point addrspace(1)* %ref_data, %struct.point addrspace(1)* %test_point_data, i32 %k) {
  %1 = alloca %struct.ref_point addrspace(1)*, align 8
  %2 = alloca %struct.point addrspace(1)*, align 8
  %3 = alloca i32, align 4
  %ref_id = alloca i32, align 4
  %test_id = alloca i32, align 4
  %4 = alloca %struct.ref_point, align 8
  %5 = alloca %struct.point, align 8
  store %struct.ref_point addrspace(1)* %ref_data, %struct.ref_point addrspace(1)** %1, align 8
  store %struct.point addrspace(1)* %test_point_data, %struct.point addrspace(1)** %2, align 8
  store i32 %k, i32* %3, align 4
  %6 = call i64 @_Z13get_global_idj(i32 0)
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %ref_id, align 4
  %8 = call i64 @_Z13get_global_idj(i32 1)
  %9 = trunc i64 %8 to i32
  store i32 %9, i32* %test_id, align 4
  %10 = load i32* %ref_id, align 4
  %11 = sext i32 %10 to i64
  %12 = load %struct.ref_point addrspace(1)** %1, align 8
  %13 = getelementptr inbounds %struct.ref_point addrspace(1)* %12, i64 %11
  %14 = load i32* %test_id, align 4
  %15 = sext i32 %14 to i64
  %16 = load %struct.point addrspace(1)** %2, align 8
  %17 = getelementptr inbounds %struct.point addrspace(1)* %16, i64 %15
  %18 = bitcast %struct.ref_point* %4 to i8*
  %19 = bitcast %struct.ref_point addrspace(1)* %13 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* %18, i8 addrspace(1)* %19, i64 24, i32 8, i1 false)
  %20 = bitcast %struct.point* %5 to i8*
  %21 = bitcast %struct.point addrspace(1)* %17 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* %20, i8 addrspace(1)* %21, i64 16, i32 8, i1 false)
  call void @calc_distance(%struct.ref_point* %4, %struct.point* %5)
  %22 = load %struct.point addrspace(1)** %2, align 8
  %23 = getelementptr inbounds %struct.point addrspace(1)* %22, i64 0
  %24 = getelementptr inbounds %struct.point addrspace(1)* %23, i32 0, i32 0
  %25 = load <2 x float> addrspace(1)* %24, align 8
  %26 = call i32 (i8 addrspace(2)*, ...)* @printf(i8 addrspace(2)* getelementptr inbounds ([36 x i8] addrspace(2)* @.str1, i32 0, i32 0), <2 x float> %25)
  ret void
}

declare i64 @_Z13get_global_idj(i32)

declare void @llvm.memcpy.p0i8.p1i8.i64(i8* nocapture, i8 addrspace(1)* nocapture, i64, i32, i1) nounwind

!opencl.kernels = !{!0}
!opencl.compiler.options = !{!7}
!opencl.enable.FP_CONTRACT = !{}

!0 = metadata !{void (%struct.ref_point addrspace(1)*, %struct.point addrspace(1)*, i32)* @knn_kernel, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"struct ref_point*", metadata !"struct point*", metadata !"uint"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"struct ref_point*", metadata !"struct point*", metadata !"uint"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"ref_data", metadata !"test_point_data", metadata !"k"}
!7 = metadata !{metadata !"-cl-std=CL1.2", metadata !"-cl-kernel-arg-info"}

; ModuleID = 'C:/Users/quincywu/Documents/GitHub/ee590-opencl/final/session_0/program.cl'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir-unknown-unknown"

%struct.ref_point = type { %struct.point, float }
%struct.point = type { <2 x float>, i32 }

@.str = private addrspace(2) unnamed_addr constant [39 x i8] c"This is dist=%f, a=%2v2hlf, b=%2v2hlf\0A\00", align 1
@.str1 = private addrspace(2) unnamed_addr constant [36 x i8] c"test_point_data_location = %2v2hlf\0A\00", align 1

define cc75 float @my_dist(<2 x float> %pointA, <2 x float> %pointB) nounwind readnone {
  %1 = extractelement <2 x float> %pointA, i32 0
  %2 = extractelement <2 x float> %pointB, i32 0
  %3 = fsub float %1, %2
  %4 = extractelement <2 x float> %pointA, i32 1
  %5 = extractelement <2 x float> %pointB, i32 1
  %6 = fsub float %4, %5
  %7 = fmul float %6, %6
  %8 = tail call float @llvm.fmuladd.f32(float %3, float %3, float %7)
  %9 = tail call cc75 float @_Z4sqrtf(float %8) nounwind readnone
  ret float %9
}

declare cc75 float @_Z4sqrtf(float) nounwind readnone

declare float @llvm.fmuladd.f32(float, float, float) nounwind readnone

define cc75 void @calc_distance(%struct.ref_point* nocapture byval %refpoints, %struct.point* nocapture byval %pointB) nounwind {
  %1 = getelementptr inbounds %struct.ref_point* %refpoints, i32 0, i32 0, i32 0
  %2 = load <2 x float>* %1, align 8, !tbaa !9
  %3 = getelementptr inbounds %struct.point* %pointB, i32 0, i32 0
  %4 = load <2 x float>* %3, align 8, !tbaa !9
  %5 = extractelement <2 x float> %2, i32 0
  %6 = extractelement <2 x float> %4, i32 0
  %7 = fsub float %5, %6
  %8 = extractelement <2 x float> %2, i32 1
  %9 = extractelement <2 x float> %4, i32 1
  %10 = fsub float %8, %9
  %11 = fmul float %10, %10
  %12 = tail call float @llvm.fmuladd.f32(float %7, float %7, float %11) nounwind
  %13 = tail call cc75 float @_Z4sqrtf(float %12) nounwind readnone
  %14 = fpext float %13 to double
  %15 = tail call cc75 i32 (i8 addrspace(2)*, ...)* @printf(i8 addrspace(2)* getelementptr inbounds ([39 x i8] addrspace(2)* @.str, i32 0, i32 0), double %14, <2 x float> %2, <2 x float> %4) nounwind
  ret void
}

declare cc75 i32 @printf(i8 addrspace(2)* nocapture, ...) nounwind

define cc76 void @knn_kernel(%struct.ref_point addrspace(1)* nocapture %ref_data, %struct.point addrspace(1)* nocapture %test_point_data, i32 %k) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = tail call cc75 i32 @_Z13get_global_idj(i32 1) nounwind readnone
  %3 = getelementptr inbounds %struct.ref_point addrspace(1)* %ref_data, i32 %1
  %4 = getelementptr inbounds %struct.point addrspace(1)* %test_point_data, i32 %2
  %5 = bitcast %struct.ref_point addrspace(1)* %3 to i8 addrspace(1)*
  %.sroa.06.0..cast = bitcast i8 addrspace(1)* %5 to <2 x float>*
  %.sroa.06.0.copyload = load <2 x float>* %.sroa.06.0..cast, align 8
  %6 = bitcast %struct.point addrspace(1)* %4 to i8 addrspace(1)*
  %.sroa.011.0..cast = bitcast i8 addrspace(1)* %6 to <2 x float>*
  %.sroa.011.0.copyload = load <2 x float>* %.sroa.011.0..cast, align 8
  %7 = extractelement <2 x float> %.sroa.06.0.copyload, i32 0
  %8 = extractelement <2 x float> %.sroa.011.0.copyload, i32 0
  %9 = fsub float %7, %8
  %10 = extractelement <2 x float> %.sroa.06.0.copyload, i32 1
  %11 = extractelement <2 x float> %.sroa.011.0.copyload, i32 1
  %12 = fsub float %10, %11
  %13 = fmul float %12, %12
  %14 = tail call float @llvm.fmuladd.f32(float %9, float %9, float %13) nounwind
  %15 = tail call cc75 float @_Z4sqrtf(float %14) nounwind readnone
  %16 = fpext float %15 to double
  %17 = tail call cc75 i32 (i8 addrspace(2)*, ...)* @printf(i8 addrspace(2)* getelementptr inbounds ([39 x i8] addrspace(2)* @.str, i32 0, i32 0), double %16, <2 x float> %.sroa.06.0.copyload, <2 x float> %.sroa.011.0.copyload) nounwind
  %18 = getelementptr inbounds %struct.point addrspace(1)* %test_point_data, i32 0, i32 0
  %19 = load <2 x float> addrspace(1)* %18, align 8, !tbaa !9
  %20 = tail call cc75 i32 (i8 addrspace(2)*, ...)* @printf(i8 addrspace(2)* getelementptr inbounds ([36 x i8] addrspace(2)* @.str1, i32 0, i32 0), <2 x float> %19) nounwind
  ret void
}

declare cc75 i32 @_Z13get_global_idj(i32) nounwind readnone

!opencl.kernels = !{!0}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!7}
!opencl.ocl.version = !{!7}
!opencl.used.extensions = !{!8}
!opencl.used.optional.core.features = !{!8}
!opencl.compiler.options = !{!8}

!0 = metadata !{void (%struct.ref_point addrspace(1)*, %struct.point addrspace(1)*, i32)* @knn_kernel, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"struct ref_point*", metadata !"struct point*", metadata !"uint"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"const"}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"struct ref_point*", metadata !"struct point*", metadata !"uint"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"ref_data", metadata !"test_point_data", metadata !"k"}
!7 = metadata !{i32 1, i32 2}
!8 = metadata !{}
!9 = metadata !{metadata !"omnipotent char", metadata !10}
!10 = metadata !{metadata !"Simple C/C++ TBAA"}

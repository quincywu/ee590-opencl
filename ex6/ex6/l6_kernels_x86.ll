; ModuleID = 'C:/Users/quincywu/Documents/GitHub/ee590-opencl/ex6/ex6/l6_kernels.cl'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir-unknown-unknown"

%opencl.image2d_t = type opaque

@sampler2 = addrspace(2) constant i32 18, align 4

define cc76 void @conv1D(float addrspace(1)* nocapture %y, float addrspace(1)* nocapture %data, i32 %dataLen, float addrspace(1)* nocapture %h_filt, i32 %filtLen) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = icmp sgt i32 %filtLen, 0
  br i1 %2, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0
  %3 = getelementptr inbounds float addrspace(1)* %y, i32 %1
  br label %4

; <label>:4                                       ; preds = %.lr.ph, %18
  %j.011 = phi i32 [ 0, %.lr.ph ], [ %19, %18 ]
  %5 = sub nsw i32 %1, %j.011
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %10

; <label>:7                                       ; preds = %4
  %8 = load float addrspace(1)* %3, align 4, !tbaa !24
  %9 = fadd float %8, 0.000000e+00
  br label %18

; <label>:10                                      ; preds = %4
  %11 = getelementptr inbounds float addrspace(1)* %data, i32 %5
  %12 = load float addrspace(1)* %11, align 4, !tbaa !24
  %13 = getelementptr inbounds float addrspace(1)* %h_filt, i32 %j.011
  %14 = load float addrspace(1)* %13, align 4, !tbaa !24
  %15 = fmul float %12, %14
  %16 = load float addrspace(1)* %3, align 4, !tbaa !24
  %17 = fadd float %16, %15
  br label %18

; <label>:18                                      ; preds = %7, %10
  %storemerge = phi float [ %17, %10 ], [ %9, %7 ]
  store float %storemerge, float addrspace(1)* %3, align 4
  %19 = add nsw i32 %j.011, 1
  %20 = icmp slt i32 %19, %filtLen
  br i1 %20, label %4, label %._crit_edge

._crit_edge:                                      ; preds = %18, %0
  ret void
}

declare cc75 i32 @_Z13get_global_idj(i32) nounwind readnone

define cc76 void @convolve_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols, float addrspace(2)* nocapture %filter, i32 %filterWidth, i32 %sampler) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = tail call cc75 i32 @_Z13get_global_idj(i32 1) nounwind readnone
  %3 = sdiv i32 %filterWidth, 2
  %4 = sub nsw i32 0, %3
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %._crit_edge43, label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %0
  %sum.040 = phi <4 x float> [ %29, %._crit_edge ], [ zeroinitializer, %0 ]
  %i.039 = phi i32 [ %32, %._crit_edge ], [ %4, %0 ]
  %coords.038 = phi <2 x i32> [ %10, %._crit_edge ], [ undef, %0 ]
  %filterIdx.037 = phi i32 [ %25, %._crit_edge ], [ 0, %0 ]
  %6 = add nsw i32 %i.039, %2
  %7 = insertelement <2 x i32> %coords.038, i32 %6, i32 1
  br label %8

; <label>:8                                       ; preds = %.lr.ph, %8
  %sum.134 = phi <4 x float> [ %sum.040, %.lr.ph ], [ %29, %8 ]
  %j.033 = phi i32 [ %4, %.lr.ph ], [ %30, %8 ]
  %coords.132 = phi <2 x i32> [ %7, %.lr.ph ], [ %10, %8 ]
  %filterIdx.131 = phi i32 [ %filterIdx.037, %.lr.ph ], [ %25, %8 ]
  %9 = add nsw i32 %j.033, %1
  %10 = insertelement <2 x i32> %coords.132, i32 %9, i32 0
  %11 = tail call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 %sampler, <2 x i32> %10) nounwind readnone
  %12 = extractelement <4 x float> %11, i32 0
  %13 = getelementptr inbounds float addrspace(2)* %filter, i32 %filterIdx.131
  %14 = load float addrspace(2)* %13, align 4, !tbaa !24
  %15 = fmul float %12, %14
  %16 = extractelement <4 x float> %sum.134, i32 0
  %17 = fadd float %16, %15
  %18 = insertelement <4 x float> %sum.134, float %17, i32 0
  %19 = extractelement <4 x float> %11, i32 1
  %20 = fmul float %19, %14
  %21 = extractelement <4 x float> %sum.134, i32 1
  %22 = fadd float %21, %20
  %23 = insertelement <4 x float> %18, float %22, i32 1
  %24 = extractelement <4 x float> %11, i32 2
  %25 = add nsw i32 %filterIdx.131, 1
  %26 = fmul float %24, %14
  %27 = extractelement <4 x float> %sum.134, i32 2
  %28 = fadd float %27, %26
  %29 = insertelement <4 x float> %23, float %28, i32 2
  %30 = add nsw i32 %j.033, 1
  %31 = icmp sgt i32 %30, %3
  br i1 %31, label %._crit_edge, label %8

._crit_edge:                                      ; preds = %8
  %32 = add nsw i32 %i.039, 1
  %33 = icmp sgt i32 %32, %3
  br i1 %33, label %._crit_edge43, label %.lr.ph

._crit_edge43:                                    ; preds = %._crit_edge, %0
  %sum.0.lcssa = phi <4 x float> [ zeroinitializer, %0 ], [ %29, %._crit_edge ]
  %34 = insertelement <2 x i32> undef, i32 %1, i32 0
  %35 = insertelement <2 x i32> %34, i32 %2, i32 1
  tail call cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %outImg, <2 x i32> %35, <4 x float> %sum.0.lcssa) nounwind
  ret void
}

declare cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)*, i32, <2 x i32>) nounwind readnone

declare cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)*, <2 x i32>, <4 x float>)

define cc76 void @sobel_edgedet_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols) nounwind {
  %sobelx = alloca [9 x i32], align 4
  %sobely = alloca [9 x i32], align 4
  %1 = call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = call cc75 i32 @_Z13get_global_idj(i32 1) nounwind readnone
  %3 = bitcast [9 x i32]* %sobelx to i8*
  call void @llvm.memset.p0i8.i32(i8* %3, i8 0, i32 36, i32 4, i1 false)
  %4 = getelementptr [9 x i32]* %sobelx, i32 0, i32 1
  store i32 1, i32* %4, align 4
  %5 = getelementptr [9 x i32]* %sobelx, i32 0, i32 3
  store i32 1, i32* %5, align 4
  %6 = getelementptr [9 x i32]* %sobelx, i32 0, i32 4
  store i32 -2, i32* %6, align 4
  %7 = getelementptr [9 x i32]* %sobelx, i32 0, i32 5
  store i32 1, i32* %7, align 4
  %8 = getelementptr [9 x i32]* %sobelx, i32 0, i32 7
  store i32 1, i32* %8, align 4
  %9 = bitcast [9 x i32]* %sobely to i8*
  call void @llvm.memset.p0i8.i32(i8* %9, i8 0, i32 36, i32 4, i1 false)
  %10 = getelementptr [9 x i32]* %sobely, i32 0, i32 1
  store i32 1, i32* %10, align 4
  %11 = getelementptr [9 x i32]* %sobely, i32 0, i32 3
  store i32 1, i32* %11, align 4
  %12 = getelementptr [9 x i32]* %sobely, i32 0, i32 4
  store i32 -2, i32* %12, align 4
  %13 = getelementptr [9 x i32]* %sobely, i32 0, i32 5
  store i32 1, i32* %13, align 4
  %14 = getelementptr [9 x i32]* %sobely, i32 0, i32 7
  store i32 1, i32* %14, align 4
  %15 = add nsw i32 %1, -1
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %0
  %sumx.034 = phi <4 x float> [ zeroinitializer, %0 ], [ %67, %._crit_edge ]
  %i.033 = phi i32 [ -1, %0 ], [ %63, %._crit_edge ]
  %filterIdx.031 = phi i32 [ 0, %0 ], [ %65, %._crit_edge ]
  %sumy.030 = phi <4 x float> [ zeroinitializer, %0 ], [ %66, %._crit_edge ]
  %17 = add nsw i32 %i.033, %2
  %18 = insertelement <2 x i32> undef, i32 %17, i32 1
  %19 = insertelement <2 x i32> %18, i32 %15, i32 0
  %20 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %19) nounwind readnone
  %21 = extractelement <4 x float> %20, i32 0
  %22 = getelementptr inbounds [9 x i32]* %sobelx, i32 0, i32 %filterIdx.031
  %23 = load i32* %22, align 4, !tbaa !27
  %24 = sitofp i32 %23 to float
  %25 = fmul float %21, %24
  %26 = extractelement <4 x float> %sumx.034, i32 0
  %27 = fadd float %26, %25
  %28 = add nsw i32 %filterIdx.031, 1
  %29 = getelementptr inbounds [9 x i32]* %sobely, i32 0, i32 %filterIdx.031
  %30 = load i32* %29, align 4, !tbaa !27
  %31 = sitofp i32 %30 to float
  %32 = fmul float %21, %31
  %33 = extractelement <4 x float> %sumy.030, i32 0
  %34 = fadd float %33, %32
  %35 = insertelement <2 x i32> %19, i32 %1, i32 0
  %36 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %35) nounwind readnone
  %37 = extractelement <4 x float> %36, i32 0
  %38 = getelementptr inbounds [9 x i32]* %sobelx, i32 0, i32 %28
  %39 = load i32* %38, align 4, !tbaa !27
  %40 = sitofp i32 %39 to float
  %41 = fmul float %37, %40
  %42 = fadd float %27, %41
  %43 = add nsw i32 %filterIdx.031, 2
  %44 = getelementptr inbounds [9 x i32]* %sobely, i32 0, i32 %28
  %45 = load i32* %44, align 4, !tbaa !27
  %46 = sitofp i32 %45 to float
  %47 = fmul float %37, %46
  %48 = fadd float %34, %47
  %49 = add nsw i32 %1, 1
  %50 = insertelement <2 x i32> %35, i32 %49, i32 0
  %51 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %50) nounwind readnone
  %52 = extractelement <4 x float> %51, i32 0
  %53 = getelementptr inbounds [9 x i32]* %sobelx, i32 0, i32 %43
  %54 = load i32* %53, align 4, !tbaa !27
  %55 = sitofp i32 %54 to float
  %56 = fmul float %52, %55
  %57 = fadd float %42, %56
  %58 = getelementptr inbounds [9 x i32]* %sobely, i32 0, i32 %43
  %59 = load i32* %58, align 4, !tbaa !27
  %60 = sitofp i32 %59 to float
  %61 = fmul float %52, %60
  %62 = fadd float %48, %61
  %63 = add nsw i32 %i.033, 1
  %64 = icmp slt i32 %63, 2
  br i1 %64, label %._crit_edge, label %68

._crit_edge:                                      ; preds = %16
  %65 = add i32 %filterIdx.031, 3
  %66 = insertelement <4 x float> %sumy.030, float %62, i32 0
  %67 = insertelement <4 x float> %sumx.034, float %57, i32 0
  br label %16

; <label>:68                                      ; preds = %16
  %69 = fmul float %62, %62
  %70 = call float @llvm.fmuladd.f32(float %57, float %57, float %69)
  %71 = call cc75 float @_Z4sqrtf(float %70) nounwind readnone
  %72 = insertelement <4 x float> <float undef, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, float %71, i32 0
  %73 = insertelement <2 x i32> undef, i32 %1, i32 0
  %74 = insertelement <2 x i32> %73, i32 %2, i32 1
  call cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %outImg, <2 x i32> %74, <4 x float> %72) nounwind
  ret void
}

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

declare cc75 float @_Z4sqrtf(float) nounwind readnone

declare float @llvm.fmuladd.f32(float, float, float) nounwind readnone

!opencl.kernels = !{!0, !7, !14}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!21}
!opencl.ocl.version = !{!21}
!opencl.used.extensions = !{!22}
!opencl.used.optional.core.features = !{!23}
!opencl.compiler.options = !{!22}

!0 = metadata !{void (float addrspace(1)*, float addrspace(1)*, i32, float addrspace(1)*, i32)* @conv1D, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0, i32 1, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"float*", metadata !"float*", metadata !"int", metadata !"float*", metadata !"int"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"float*", metadata !"float*", metadata !"int", metadata !"float*", metadata !"int"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"y", metadata !"data", metadata !"dataLen", metadata !"h_filt", metadata !"filtLen"}
!7 = metadata !{void (%opencl.image2d_t addrspace(1)*, %opencl.image2d_t addrspace(1)*, i32, i32, float addrspace(2)*, i32, i32)* @convolve_v1, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !13}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0, i32 0, i32 2, i32 0, i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"read_only", metadata !"write_only", metadata !"none", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"image2d_t", metadata !"image2d_t", metadata !"int", metadata !"int", metadata !"float*", metadata !"int", metadata !"sampler_t"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !"", metadata !"const", metadata !"", metadata !""}
!12 = metadata !{metadata !"kernel_arg_base_type", metadata !"image2d_t", metadata !"image2d_t", metadata !"int", metadata !"int", metadata !"float*", metadata !"int", metadata !"sampler_t"}
!13 = metadata !{metadata !"kernel_arg_name", metadata !"inImg", metadata !"outImg", metadata !"rows", metadata !"cols", metadata !"filter", metadata !"filterWidth", metadata !"sampler"}
!14 = metadata !{void (%opencl.image2d_t addrspace(1)*, %opencl.image2d_t addrspace(1)*, i32, i32)* @sobel_edgedet_v1, metadata !15, metadata !16, metadata !17, metadata !18, metadata !19, metadata !20}
!15 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0, i32 0}
!16 = metadata !{metadata !"kernel_arg_access_qual", metadata !"read_only", metadata !"write_only", metadata !"none", metadata !"none"}
!17 = metadata !{metadata !"kernel_arg_type", metadata !"image2d_t", metadata !"image2d_t", metadata !"int", metadata !"int"}
!18 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !""}
!19 = metadata !{metadata !"kernel_arg_base_type", metadata !"image2d_t", metadata !"image2d_t", metadata !"int", metadata !"int"}
!20 = metadata !{metadata !"kernel_arg_name", metadata !"inImg", metadata !"outImg", metadata !"rows", metadata !"cols"}
!21 = metadata !{i32 1, i32 2}
!22 = metadata !{}
!23 = metadata !{metadata !"cl_images"}
!24 = metadata !{metadata !"float", metadata !25}
!25 = metadata !{metadata !"omnipotent char", metadata !26}
!26 = metadata !{metadata !"Simple C/C++ TBAA"}
!27 = metadata !{metadata !"int", metadata !25}

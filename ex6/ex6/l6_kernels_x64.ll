; ModuleID = 'C:/Users/quincywu/Documents/GitHub/ee590-opencl/ex6/ex6/l6_kernels.cl'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir64-unknown-unknown"

%opencl.image2d_t = type opaque

@sampler2 = addrspace(2) constant i32 18, align 4

define cc76 void @conv1D(float addrspace(1)* nocapture %y, float addrspace(1)* nocapture %data, i32 %dataLen, float addrspace(1)* nocapture %h_filt, i32 %filtLen) nounwind {
  %1 = tail call cc75 i64 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = trunc i64 %1 to i32
  %3 = icmp sgt i32 %filtLen, 0
  br i1 %3, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0
  %4 = sext i32 %2 to i64
  %5 = getelementptr inbounds float addrspace(1)* %y, i64 %4
  br label %6

; <label>:6                                       ; preds = %.lr.ph, %22
  %j.011 = phi i32 [ 0, %.lr.ph ], [ %23, %22 ]
  %7 = sub nsw i32 %2, %j.011
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %12

; <label>:9                                       ; preds = %6
  %10 = load float addrspace(1)* %5, align 4, !tbaa !24
  %11 = fadd float %10, 0.000000e+00
  br label %22

; <label>:12                                      ; preds = %6
  %13 = sext i32 %7 to i64
  %14 = getelementptr inbounds float addrspace(1)* %data, i64 %13
  %15 = load float addrspace(1)* %14, align 4, !tbaa !24
  %16 = sext i32 %j.011 to i64
  %17 = getelementptr inbounds float addrspace(1)* %h_filt, i64 %16
  %18 = load float addrspace(1)* %17, align 4, !tbaa !24
  %19 = fmul float %15, %18
  %20 = load float addrspace(1)* %5, align 4, !tbaa !24
  %21 = fadd float %20, %19
  br label %22

; <label>:22                                      ; preds = %9, %12
  %storemerge = phi float [ %21, %12 ], [ %11, %9 ]
  store float %storemerge, float addrspace(1)* %5, align 4
  %23 = add nsw i32 %j.011, 1
  %24 = icmp slt i32 %23, %filtLen
  br i1 %24, label %6, label %._crit_edge

._crit_edge:                                      ; preds = %22, %0
  ret void
}

declare cc75 i64 @_Z13get_global_idj(i32) nounwind readnone

define cc76 void @convolve_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols, float addrspace(2)* nocapture %filter, i32 %filterWidth, i32 %sampler) nounwind {
  %1 = tail call cc75 i64 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = trunc i64 %1 to i32
  %3 = tail call cc75 i64 @_Z13get_global_idj(i32 1) nounwind readnone
  %4 = trunc i64 %3 to i32
  %5 = sdiv i32 %filterWidth, 2
  %6 = sub nsw i32 0, %5
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %._crit_edge43, label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %0
  %sum.040 = phi <4 x float> [ %32, %._crit_edge ], [ zeroinitializer, %0 ]
  %i.039 = phi i32 [ %35, %._crit_edge ], [ %6, %0 ]
  %coords.038 = phi <2 x i32> [ %12, %._crit_edge ], [ undef, %0 ]
  %filterIdx.037 = phi i32 [ %28, %._crit_edge ], [ 0, %0 ]
  %8 = add nsw i32 %i.039, %4
  %9 = insertelement <2 x i32> %coords.038, i32 %8, i32 1
  br label %10

; <label>:10                                      ; preds = %.lr.ph, %10
  %sum.134 = phi <4 x float> [ %sum.040, %.lr.ph ], [ %32, %10 ]
  %j.033 = phi i32 [ %6, %.lr.ph ], [ %33, %10 ]
  %coords.132 = phi <2 x i32> [ %9, %.lr.ph ], [ %12, %10 ]
  %filterIdx.131 = phi i32 [ %filterIdx.037, %.lr.ph ], [ %28, %10 ]
  %11 = add nsw i32 %j.033, %2
  %12 = insertelement <2 x i32> %coords.132, i32 %11, i32 0
  %13 = tail call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 %sampler, <2 x i32> %12) nounwind readnone
  %14 = extractelement <4 x float> %13, i32 0
  %15 = sext i32 %filterIdx.131 to i64
  %16 = getelementptr inbounds float addrspace(2)* %filter, i64 %15
  %17 = load float addrspace(2)* %16, align 4, !tbaa !24
  %18 = fmul float %14, %17
  %19 = extractelement <4 x float> %sum.134, i32 0
  %20 = fadd float %19, %18
  %21 = insertelement <4 x float> %sum.134, float %20, i32 0
  %22 = extractelement <4 x float> %13, i32 1
  %23 = fmul float %22, %17
  %24 = extractelement <4 x float> %sum.134, i32 1
  %25 = fadd float %24, %23
  %26 = insertelement <4 x float> %21, float %25, i32 1
  %27 = extractelement <4 x float> %13, i32 2
  %28 = add nsw i32 %filterIdx.131, 1
  %29 = fmul float %27, %17
  %30 = extractelement <4 x float> %sum.134, i32 2
  %31 = fadd float %30, %29
  %32 = insertelement <4 x float> %26, float %31, i32 2
  %33 = add nsw i32 %j.033, 1
  %34 = icmp sgt i32 %33, %5
  br i1 %34, label %._crit_edge, label %10

._crit_edge:                                      ; preds = %10
  %35 = add nsw i32 %i.039, 1
  %36 = icmp sgt i32 %35, %5
  br i1 %36, label %._crit_edge43, label %.lr.ph

._crit_edge43:                                    ; preds = %._crit_edge, %0
  %sum.0.lcssa = phi <4 x float> [ zeroinitializer, %0 ], [ %32, %._crit_edge ]
  %37 = insertelement <2 x i32> undef, i32 %2, i32 0
  %38 = insertelement <2 x i32> %37, i32 %4, i32 1
  tail call cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %outImg, <2 x i32> %38, <4 x float> %sum.0.lcssa) nounwind
  ret void
}

declare cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)*, i32, <2 x i32>) nounwind readnone

declare cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)*, <2 x i32>, <4 x float>)

define cc76 void @sobel_edgedet_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols) nounwind {
  %sobelx = alloca [9 x i32], align 4
  %sobely = alloca [9 x i32], align 4
  %1 = call cc75 i64 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = trunc i64 %1 to i32
  %3 = call cc75 i64 @_Z13get_global_idj(i32 1) nounwind readnone
  %4 = trunc i64 %3 to i32
  %5 = bitcast [9 x i32]* %sobelx to i8*
  call void @llvm.memset.p0i8.i64(i8* %5, i8 0, i64 36, i32 4, i1 false)
  %6 = getelementptr [9 x i32]* %sobelx, i64 0, i64 1
  store i32 1, i32* %6, align 4
  %7 = getelementptr [9 x i32]* %sobelx, i64 0, i64 3
  store i32 1, i32* %7, align 4
  %8 = getelementptr [9 x i32]* %sobelx, i64 0, i64 4
  store i32 -2, i32* %8, align 4
  %9 = getelementptr [9 x i32]* %sobelx, i64 0, i64 5
  store i32 1, i32* %9, align 4
  %10 = getelementptr [9 x i32]* %sobelx, i64 0, i64 7
  store i32 1, i32* %10, align 4
  %11 = bitcast [9 x i32]* %sobely to i8*
  call void @llvm.memset.p0i8.i64(i8* %11, i8 0, i64 36, i32 4, i1 false)
  %12 = getelementptr [9 x i32]* %sobely, i64 0, i64 1
  store i32 1, i32* %12, align 4
  %13 = getelementptr [9 x i32]* %sobely, i64 0, i64 3
  store i32 1, i32* %13, align 4
  %14 = getelementptr [9 x i32]* %sobely, i64 0, i64 4
  store i32 -2, i32* %14, align 4
  %15 = getelementptr [9 x i32]* %sobely, i64 0, i64 5
  store i32 1, i32* %15, align 4
  %16 = getelementptr [9 x i32]* %sobely, i64 0, i64 7
  store i32 1, i32* %16, align 4
  %17 = add nsw i32 %2, -1
  br label %18

; <label>:18                                      ; preds = %._crit_edge, %0
  %sumx.034 = phi <4 x float> [ zeroinitializer, %0 ], [ %72, %._crit_edge ]
  %i.033 = phi i32 [ -1, %0 ], [ %68, %._crit_edge ]
  %filterIdx.031 = phi i32 [ 0, %0 ], [ %70, %._crit_edge ]
  %sumy.030 = phi <4 x float> [ zeroinitializer, %0 ], [ %71, %._crit_edge ]
  %19 = add nsw i32 %i.033, %4
  %20 = insertelement <2 x i32> undef, i32 %19, i32 1
  %21 = insertelement <2 x i32> %20, i32 %17, i32 0
  %22 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %21) nounwind readnone
  %23 = extractelement <4 x float> %22, i32 0
  %24 = sext i32 %filterIdx.031 to i64
  %25 = getelementptr inbounds [9 x i32]* %sobelx, i64 0, i64 %24
  %26 = load i32* %25, align 4, !tbaa !27
  %27 = sitofp i32 %26 to float
  %28 = fmul float %23, %27
  %29 = extractelement <4 x float> %sumx.034, i32 0
  %30 = fadd float %29, %28
  %31 = add nsw i32 %filterIdx.031, 1
  %32 = getelementptr inbounds [9 x i32]* %sobely, i64 0, i64 %24
  %33 = load i32* %32, align 4, !tbaa !27
  %34 = sitofp i32 %33 to float
  %35 = fmul float %23, %34
  %36 = extractelement <4 x float> %sumy.030, i32 0
  %37 = fadd float %36, %35
  %38 = insertelement <2 x i32> %21, i32 %2, i32 0
  %39 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %38) nounwind readnone
  %40 = extractelement <4 x float> %39, i32 0
  %41 = sext i32 %31 to i64
  %42 = getelementptr inbounds [9 x i32]* %sobelx, i64 0, i64 %41
  %43 = load i32* %42, align 4, !tbaa !27
  %44 = sitofp i32 %43 to float
  %45 = fmul float %40, %44
  %46 = fadd float %30, %45
  %47 = add nsw i32 %filterIdx.031, 2
  %48 = getelementptr inbounds [9 x i32]* %sobely, i64 0, i64 %41
  %49 = load i32* %48, align 4, !tbaa !27
  %50 = sitofp i32 %49 to float
  %51 = fmul float %40, %50
  %52 = fadd float %37, %51
  %53 = add nsw i32 %2, 1
  %54 = insertelement <2 x i32> %38, i32 %53, i32 0
  %55 = call cc75 <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %inImg, i32 18, <2 x i32> %54) nounwind readnone
  %56 = extractelement <4 x float> %55, i32 0
  %57 = sext i32 %47 to i64
  %58 = getelementptr inbounds [9 x i32]* %sobelx, i64 0, i64 %57
  %59 = load i32* %58, align 4, !tbaa !27
  %60 = sitofp i32 %59 to float
  %61 = fmul float %56, %60
  %62 = fadd float %46, %61
  %63 = getelementptr inbounds [9 x i32]* %sobely, i64 0, i64 %57
  %64 = load i32* %63, align 4, !tbaa !27
  %65 = sitofp i32 %64 to float
  %66 = fmul float %56, %65
  %67 = fadd float %52, %66
  %68 = add nsw i32 %i.033, 1
  %69 = icmp slt i32 %68, 2
  br i1 %69, label %._crit_edge, label %73

._crit_edge:                                      ; preds = %18
  %70 = add i32 %filterIdx.031, 3
  %71 = insertelement <4 x float> %sumy.030, float %67, i32 0
  %72 = insertelement <4 x float> %sumx.034, float %62, i32 0
  br label %18

; <label>:73                                      ; preds = %18
  %74 = fmul float %67, %67
  %75 = call float @llvm.fmuladd.f32(float %62, float %62, float %74)
  %76 = call cc75 float @_Z4sqrtf(float %75) nounwind readnone
  %77 = insertelement <4 x float> <float undef, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, float %76, i32 0
  %78 = insertelement <2 x i32> undef, i32 %2, i32 0
  %79 = insertelement <2 x i32> %78, i32 %4, i32 1
  call cc75 void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %outImg, <2 x i32> %79, <4 x float> %77) nounwind
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) nounwind

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

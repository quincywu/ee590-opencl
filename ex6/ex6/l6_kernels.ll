; ModuleID = 'C:\Users\quincywu\AppData\Local\Temp\e6199911-55b5-493e-a373-adbaaacabf2b.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f80:128:128-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-f80:128:128-n8:16:32:64"
target triple = "igil_64_GEN9"

%opencl.image2d_t = type opaque

@sampler2 = addrspace(2) constant i32 2, align 4

define void @conv1D(float addrspace(1)* %y, float addrspace(1)* %data, i32 %dataLen, float addrspace(1)* %h_filt, i32 %filtLen) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %3 = alloca i32, align 4
  %4 = alloca float addrspace(1)*, align 8
  %5 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store float addrspace(1)* %y, float addrspace(1)** %1, align 8
  store float addrspace(1)* %data, float addrspace(1)** %2, align 8
  store i32 %dataLen, i32* %3, align 4
  store float addrspace(1)* %h_filt, float addrspace(1)** %4, align 8
  store i32 %filtLen, i32* %5, align 4
  %6 = call i64 @_Z13get_global_idj(i32 0)
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %i, align 4
  store i32 0, i32* %j, align 4
  br label %8

; <label>:8                                       ; preds = %46, %0
  %9 = load i32* %j, align 4
  %10 = load i32* %5, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %49

; <label>:12                                      ; preds = %8
  %13 = load i32* %i, align 4
  %14 = load i32* %j, align 4
  %15 = sub nsw i32 %13, %14
  %16 = icmp sgt i32 0, %15
  br i1 %16, label %17, label %24

; <label>:17                                      ; preds = %12
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load float addrspace(1)** %1, align 8
  %21 = getelementptr inbounds float addrspace(1)* %20, i64 %19
  %22 = load float addrspace(1)* %21, align 4
  %23 = fadd float %22, 0.000000e+00
  store float %23, float addrspace(1)* %21, align 4
  br label %44

; <label>:24                                      ; preds = %12
  %25 = load i32* %i, align 4
  %26 = load i32* %j, align 4
  %27 = sub nsw i32 %25, %26
  %28 = sext i32 %27 to i64
  %29 = load float addrspace(1)** %2, align 8
  %30 = getelementptr inbounds float addrspace(1)* %29, i64 %28
  %31 = load float addrspace(1)* %30, align 4
  %32 = load i32* %j, align 4
  %33 = sext i32 %32 to i64
  %34 = load float addrspace(1)** %4, align 8
  %35 = getelementptr inbounds float addrspace(1)* %34, i64 %33
  %36 = load float addrspace(1)* %35, align 4
  %37 = fmul float %31, %36
  %38 = load i32* %i, align 4
  %39 = sext i32 %38 to i64
  %40 = load float addrspace(1)** %1, align 8
  %41 = getelementptr inbounds float addrspace(1)* %40, i64 %39
  %42 = load float addrspace(1)* %41, align 4
  %43 = fadd float %42, %37
  store float %43, float addrspace(1)* %41, align 4
  br label %44

; <label>:44                                      ; preds = %24, %17
  %45 = phi float [ %23, %17 ], [ %43, %24 ]
  br label %46

; <label>:46                                      ; preds = %44
  %47 = load i32* %j, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, i32* %j, align 4
  br label %8

; <label>:49                                      ; preds = %8
  ret void
}

declare i64 @_Z13get_global_idj(i32)

define void @convolve_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols, float addrspace(2)* %filter, i32 %filterWidth, i32 %sampler) {
  %1 = alloca %opencl.image2d_t addrspace(1)*, align 8
  %2 = alloca %opencl.image2d_t addrspace(1)*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca float addrspace(2)*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %column = alloca i32, align 4
  %row = alloca i32, align 4
  %halfWidth = alloca i32, align 4
  %sum = alloca <4 x float>, align 16
  %filterIdx = alloca i32, align 4
  %coords = alloca <2 x i32>, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %pixel = alloca <4 x float>, align 16
  store %opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)** %1, align 8
  store %opencl.image2d_t addrspace(1)* %outImg, %opencl.image2d_t addrspace(1)** %2, align 8
  store i32 %rows, i32* %3, align 4
  store i32 %cols, i32* %4, align 4
  store float addrspace(2)* %filter, float addrspace(2)** %5, align 8
  store i32 %filterWidth, i32* %6, align 4
  store i32 %sampler, i32* %7, align 4
  %8 = call i64 @_Z13get_global_idj(i32 0)
  %9 = trunc i64 %8 to i32
  store i32 %9, i32* %column, align 4
  %10 = call i64 @_Z13get_global_idj(i32 1)
  %11 = trunc i64 %10 to i32
  store i32 %11, i32* %row, align 4
  %12 = load i32* %6, align 4
  %13 = sdiv i32 %12, 2
  store i32 %13, i32* %halfWidth, align 4
  store <4 x float> zeroinitializer, <4 x float>* %sum, align 16
  store i32 0, i32* %filterIdx, align 4
  %14 = load i32* %halfWidth, align 4
  %15 = sub nsw i32 0, %14
  store i32 %15, i32* %i, align 4
  br label %16

; <label>:16                                      ; preds = %86, %0
  %17 = load i32* %i, align 4
  %18 = load i32* %halfWidth, align 4
  %19 = icmp sle i32 %17, %18
  br i1 %19, label %20, label %89

; <label>:20                                      ; preds = %16
  %21 = load i32* %row, align 4
  %22 = load i32* %i, align 4
  %23 = add nsw i32 %21, %22
  %24 = load <2 x i32>* %coords, align 8
  %25 = insertelement <2 x i32> %24, i32 %23, i32 1
  store <2 x i32> %25, <2 x i32>* %coords, align 8
  %26 = load i32* %halfWidth, align 4
  %27 = sub nsw i32 0, %26
  store i32 %27, i32* %j, align 4
  br label %28

; <label>:28                                      ; preds = %82, %20
  %29 = load i32* %j, align 4
  %30 = load i32* %halfWidth, align 4
  %31 = icmp sle i32 %29, %30
  br i1 %31, label %32, label %85

; <label>:32                                      ; preds = %28
  %33 = load i32* %column, align 4
  %34 = load i32* %j, align 4
  %35 = add nsw i32 %33, %34
  %36 = load <2 x i32>* %coords, align 8
  %37 = insertelement <2 x i32> %36, i32 %35, i32 0
  store <2 x i32> %37, <2 x i32>* %coords, align 8
  %38 = load %opencl.image2d_t addrspace(1)** %1, align 8
  %39 = load i32* %7, align 4
  %40 = load <2 x i32>* %coords, align 8
  %41 = call <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %38, i32 %39, <2 x i32> %40)
  store <4 x float> %41, <4 x float>* %pixel, align 16
  %42 = load <4 x float>* %pixel, align 16
  %43 = extractelement <4 x float> %42, i32 0
  %44 = load i32* %filterIdx, align 4
  %45 = sext i32 %44 to i64
  %46 = load float addrspace(2)** %5, align 8
  %47 = getelementptr inbounds float addrspace(2)* %46, i64 %45
  %48 = load float addrspace(2)* %47, align 4
  %49 = fmul float %43, %48
  %50 = load <4 x float>* %sum, align 16
  %51 = extractelement <4 x float> %50, i32 0
  %52 = fadd float %51, %49
  %53 = load <4 x float>* %sum, align 16
  %54 = insertelement <4 x float> %53, float %52, i32 0
  store <4 x float> %54, <4 x float>* %sum, align 16
  %55 = load <4 x float>* %pixel, align 16
  %56 = extractelement <4 x float> %55, i32 1
  %57 = load i32* %filterIdx, align 4
  %58 = sext i32 %57 to i64
  %59 = load float addrspace(2)** %5, align 8
  %60 = getelementptr inbounds float addrspace(2)* %59, i64 %58
  %61 = load float addrspace(2)* %60, align 4
  %62 = fmul float %56, %61
  %63 = load <4 x float>* %sum, align 16
  %64 = extractelement <4 x float> %63, i32 1
  %65 = fadd float %64, %62
  %66 = load <4 x float>* %sum, align 16
  %67 = insertelement <4 x float> %66, float %65, i32 1
  store <4 x float> %67, <4 x float>* %sum, align 16
  %68 = load <4 x float>* %pixel, align 16
  %69 = extractelement <4 x float> %68, i32 2
  %70 = load i32* %filterIdx, align 4
  %71 = add nsw i32 %70, 1
  store i32 %71, i32* %filterIdx, align 4
  %72 = sext i32 %70 to i64
  %73 = load float addrspace(2)** %5, align 8
  %74 = getelementptr inbounds float addrspace(2)* %73, i64 %72
  %75 = load float addrspace(2)* %74, align 4
  %76 = fmul float %69, %75
  %77 = load <4 x float>* %sum, align 16
  %78 = extractelement <4 x float> %77, i32 2
  %79 = fadd float %78, %76
  %80 = load <4 x float>* %sum, align 16
  %81 = insertelement <4 x float> %80, float %79, i32 2
  store <4 x float> %81, <4 x float>* %sum, align 16
  br label %82

; <label>:82                                      ; preds = %32
  %83 = load i32* %j, align 4
  %84 = add nsw i32 %83, 1
  store i32 %84, i32* %j, align 4
  br label %28

; <label>:85                                      ; preds = %28
  br label %86

; <label>:86                                      ; preds = %85
  %87 = load i32* %i, align 4
  %88 = add nsw i32 %87, 1
  store i32 %88, i32* %i, align 4
  br label %16

; <label>:89                                      ; preds = %16
  %90 = load i32* %column, align 4
  %91 = load <2 x i32>* %coords, align 8
  %92 = insertelement <2 x i32> %91, i32 %90, i32 0
  store <2 x i32> %92, <2 x i32>* %coords, align 8
  %93 = load i32* %row, align 4
  %94 = load <2 x i32>* %coords, align 8
  %95 = insertelement <2 x i32> %94, i32 %93, i32 1
  store <2 x i32> %95, <2 x i32>* %coords, align 8
  %96 = load %opencl.image2d_t addrspace(1)** %2, align 8
  %97 = load <2 x i32>* %coords, align 8
  %98 = load <4 x float>* %sum, align 16
  call void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %96, <2 x i32> %97, <4 x float> %98)
  ret void
}

declare <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)*, i32, <2 x i32>)

declare void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)*, <2 x i32>, <4 x float>)

define void @sobel_edgedet_v1(%opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)* %outImg, i32 %rows, i32 %cols) {
  %1 = alloca %opencl.image2d_t addrspace(1)*, align 8
  %2 = alloca %opencl.image2d_t addrspace(1)*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %column = alloca i32, align 4
  %row = alloca i32, align 4
  %filterWidth = alloca i32, align 4
  %sobelx = alloca [9 x i32], align 4
  %sobely = alloca [9 x i32], align 4
  %halfWidth = alloca i32, align 4
  %sumx = alloca <4 x float>, align 16
  %sumy = alloca <4 x float>, align 16
  %px_grad = alloca <4 x float>, align 16
  %filterIdx = alloca i32, align 4
  %coords = alloca <2 x i32>, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %pixel = alloca <4 x float>, align 16
  store %opencl.image2d_t addrspace(1)* %inImg, %opencl.image2d_t addrspace(1)** %1, align 8
  store %opencl.image2d_t addrspace(1)* %outImg, %opencl.image2d_t addrspace(1)** %2, align 8
  store i32 %rows, i32* %3, align 4
  store i32 %cols, i32* %4, align 4
  %5 = call i64 @_Z13get_global_idj(i32 0)
  %6 = trunc i64 %5 to i32
  store i32 %6, i32* %column, align 4
  %7 = call i64 @_Z13get_global_idj(i32 1)
  %8 = trunc i64 %7 to i32
  store i32 %8, i32* %row, align 4
  store i32 3, i32* %filterWidth, align 4
  %9 = bitcast [9 x i32]* %sobelx to i8*
  call void @llvm.memset.p0i8.i64(i8* %9, i8 0, i64 36, i32 4, i1 false)
  %10 = bitcast i8* %9 to [9 x i32]*
  %11 = getelementptr [9 x i32]* %10, i32 0, i32 1
  store i32 1, i32* %11
  %12 = getelementptr [9 x i32]* %10, i32 0, i32 3
  store i32 1, i32* %12
  %13 = getelementptr [9 x i32]* %10, i32 0, i32 4
  store i32 -2, i32* %13
  %14 = getelementptr [9 x i32]* %10, i32 0, i32 5
  store i32 1, i32* %14
  %15 = getelementptr [9 x i32]* %10, i32 0, i32 7
  store i32 1, i32* %15
  %16 = bitcast [9 x i32]* %sobely to i8*
  call void @llvm.memset.p0i8.i64(i8* %16, i8 0, i64 36, i32 4, i1 false)
  %17 = bitcast i8* %16 to [9 x i32]*
  %18 = getelementptr [9 x i32]* %17, i32 0, i32 1
  store i32 1, i32* %18
  %19 = getelementptr [9 x i32]* %17, i32 0, i32 3
  store i32 1, i32* %19
  %20 = getelementptr [9 x i32]* %17, i32 0, i32 4
  store i32 -2, i32* %20
  %21 = getelementptr [9 x i32]* %17, i32 0, i32 5
  store i32 1, i32* %21
  %22 = getelementptr [9 x i32]* %17, i32 0, i32 7
  store i32 1, i32* %22
  %23 = load i32* %filterWidth, align 4
  %24 = sdiv i32 %23, 2
  store i32 %24, i32* %halfWidth, align 4
  store <4 x float> zeroinitializer, <4 x float>* %sumx, align 16
  store <4 x float> zeroinitializer, <4 x float>* %sumy, align 16
  store <4 x float> zeroinitializer, <4 x float>* %px_grad, align 16
  store i32 0, i32* %filterIdx, align 4
  %25 = load i32* %halfWidth, align 4
  %26 = sub nsw i32 0, %25
  store i32 %26, i32* %i, align 4
  br label %27

; <label>:27                                      ; preds = %84, %0
  %28 = load i32* %i, align 4
  %29 = load i32* %halfWidth, align 4
  %30 = icmp sle i32 %28, %29
  br i1 %30, label %31, label %87

; <label>:31                                      ; preds = %27
  %32 = load i32* %row, align 4
  %33 = load i32* %i, align 4
  %34 = add nsw i32 %32, %33
  %35 = load <2 x i32>* %coords, align 8
  %36 = insertelement <2 x i32> %35, i32 %34, i32 1
  store <2 x i32> %36, <2 x i32>* %coords, align 8
  %37 = load i32* %halfWidth, align 4
  %38 = sub nsw i32 0, %37
  store i32 %38, i32* %j, align 4
  br label %39

; <label>:39                                      ; preds = %80, %31
  %40 = load i32* %j, align 4
  %41 = load i32* %halfWidth, align 4
  %42 = icmp sle i32 %40, %41
  br i1 %42, label %43, label %83

; <label>:43                                      ; preds = %39
  %44 = load i32* %column, align 4
  %45 = load i32* %j, align 4
  %46 = add nsw i32 %44, %45
  %47 = load <2 x i32>* %coords, align 8
  %48 = insertelement <2 x i32> %47, i32 %46, i32 0
  store <2 x i32> %48, <2 x i32>* %coords, align 8
  %49 = load %opencl.image2d_t addrspace(1)** %1, align 8
  %50 = load i32 addrspace(2)* @sampler2, align 4
  %51 = load <2 x i32>* %coords, align 8
  %52 = call <4 x float> @_Z11read_imagef11ocl_image2d11ocl_samplerDv2_i(%opencl.image2d_t addrspace(1)* %49, i32 %50, <2 x i32> %51)
  store <4 x float> %52, <4 x float>* %pixel, align 16
  %53 = load <4 x float>* %pixel, align 16
  %54 = extractelement <4 x float> %53, i32 0
  %55 = load i32* %filterIdx, align 4
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds [9 x i32]* %sobelx, i32 0, i64 %56
  %58 = load i32* %57, align 4
  %59 = sitofp i32 %58 to float
  %60 = fmul float %54, %59
  %61 = load <4 x float>* %sumx, align 16
  %62 = extractelement <4 x float> %61, i32 0
  %63 = fadd float %62, %60
  %64 = load <4 x float>* %sumx, align 16
  %65 = insertelement <4 x float> %64, float %63, i32 0
  store <4 x float> %65, <4 x float>* %sumx, align 16
  %66 = load <4 x float>* %pixel, align 16
  %67 = extractelement <4 x float> %66, i32 0
  %68 = load i32* %filterIdx, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %filterIdx, align 4
  %70 = sext i32 %68 to i64
  %71 = getelementptr inbounds [9 x i32]* %sobely, i32 0, i64 %70
  %72 = load i32* %71, align 4
  %73 = sitofp i32 %72 to float
  %74 = fmul float %67, %73
  %75 = load <4 x float>* %sumy, align 16
  %76 = extractelement <4 x float> %75, i32 0
  %77 = fadd float %76, %74
  %78 = load <4 x float>* %sumy, align 16
  %79 = insertelement <4 x float> %78, float %77, i32 0
  store <4 x float> %79, <4 x float>* %sumy, align 16
  br label %80

; <label>:80                                      ; preds = %43
  %81 = load i32* %j, align 4
  %82 = add nsw i32 %81, 1
  store i32 %82, i32* %j, align 4
  br label %39

; <label>:83                                      ; preds = %39
  br label %84

; <label>:84                                      ; preds = %83
  %85 = load i32* %i, align 4
  %86 = add nsw i32 %85, 1
  store i32 %86, i32* %i, align 4
  br label %27

; <label>:87                                      ; preds = %27
  %88 = load <4 x float>* %sumx, align 16
  %89 = extractelement <4 x float> %88, i32 0
  %90 = load <4 x float>* %sumx, align 16
  %91 = extractelement <4 x float> %90, i32 0
  %92 = fmul float %89, %91
  %93 = load <4 x float>* %sumy, align 16
  %94 = extractelement <4 x float> %93, i32 0
  %95 = load <4 x float>* %sumy, align 16
  %96 = extractelement <4 x float> %95, i32 0
  %97 = fmul float %94, %96
  %98 = fadd float %92, %97
  %99 = call float @_Z4sqrtf(float %98)
  %100 = load <4 x float>* %px_grad, align 16
  %101 = insertelement <4 x float> %100, float %99, i32 0
  store <4 x float> %101, <4 x float>* %px_grad, align 16
  %102 = load i32* %column, align 4
  %103 = load <2 x i32>* %coords, align 8
  %104 = insertelement <2 x i32> %103, i32 %102, i32 0
  store <2 x i32> %104, <2 x i32>* %coords, align 8
  %105 = load i32* %row, align 4
  %106 = load <2 x i32>* %coords, align 8
  %107 = insertelement <2 x i32> %106, i32 %105, i32 1
  store <2 x i32> %107, <2 x i32>* %coords, align 8
  %108 = load %opencl.image2d_t addrspace(1)** %2, align 8
  %109 = load <2 x i32>* %coords, align 8
  %110 = load <4 x float>* %px_grad, align 16
  call void @_Z12write_imagef11ocl_image2dDv2_iDv4_f(%opencl.image2d_t addrspace(1)* %108, <2 x i32> %109, <4 x float> %110)
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) nounwind

declare float @_Z4sqrtf(float)

!opencl.kernels = !{!0, !7, !14}
!opencl.compiler.options = !{!21}
!opencl.enable.FP_CONTRACT = !{}

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
!21 = metadata !{metadata !"-cl-std=CL1.2", metadata !"-cl-kernel-arg-info"}

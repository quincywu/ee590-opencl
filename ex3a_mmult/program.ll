; ModuleID = 'C:\Users\quincywu\AppData\Local\Temp\32cf820e-a99f-49b1-a840-4c77fc4c98c1.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f80:128:128-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-f80:128:128-n8:16:32:64"
target triple = "igil_64_GEN9"

define void @mmult_v1(i32 %N, float addrspace(1)* %A, float addrspace(1)* %B, float addrspace(1)* %C) {
  %1 = alloca i32, align 4
  %2 = alloca float addrspace(1)*, align 8
  %3 = alloca float addrspace(1)*, align 8
  %4 = alloca float addrspace(1)*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %tem = alloca float, align 4
  store i32 %N, i32* %1, align 4
  store float addrspace(1)* %A, float addrspace(1)** %2, align 8
  store float addrspace(1)* %B, float addrspace(1)** %3, align 8
  store float addrspace(1)* %C, float addrspace(1)** %4, align 8
  %5 = call i64 @_Z13get_global_idj(i32 0)
  %6 = trunc i64 %5 to i32
  store i32 %6, i32* %i, align 4
  %7 = call i64 @_Z13get_global_idj(i32 1)
  %8 = trunc i64 %7 to i32
  store i32 %8, i32* %j, align 4
  store float 0.000000e+00, float* %tem, align 4
  store i32 0, i32* %k, align 4
  br label %9

; <label>:9                                       ; preds = %35, %0
  %10 = load i32* %k, align 4
  %11 = load i32* %1, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %38

; <label>:13                                      ; preds = %9
  %14 = load i32* %i, align 4
  %15 = load i32* %1, align 4
  %16 = mul nsw i32 %14, %15
  %17 = load i32* %k, align 4
  %18 = add nsw i32 %16, %17
  %19 = sext i32 %18 to i64
  %20 = load float addrspace(1)** %2, align 8
  %21 = getelementptr inbounds float addrspace(1)* %20, i64 %19
  %22 = load float addrspace(1)* %21, align 4
  %23 = load i32* %k, align 4
  %24 = load i32* %1, align 4
  %25 = mul nsw i32 %23, %24
  %26 = load i32* %j, align 4
  %27 = add nsw i32 %25, %26
  %28 = sext i32 %27 to i64
  %29 = load float addrspace(1)** %3, align 8
  %30 = getelementptr inbounds float addrspace(1)* %29, i64 %28
  %31 = load float addrspace(1)* %30, align 4
  %32 = fmul float %22, %31
  %33 = load float* %tem, align 4
  %34 = fadd float %33, %32
  store float %34, float* %tem, align 4
  br label %35

; <label>:35                                      ; preds = %13
  %36 = load i32* %k, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, i32* %k, align 4
  br label %9

; <label>:38                                      ; preds = %9
  %39 = load float* %tem, align 4
  %40 = load i32* %i, align 4
  %41 = load i32* %1, align 4
  %42 = mul nsw i32 %40, %41
  %43 = load i32* %j, align 4
  %44 = add nsw i32 %42, %43
  %45 = sext i32 %44 to i64
  %46 = load float addrspace(1)** %4, align 8
  %47 = getelementptr inbounds float addrspace(1)* %46, i64 %45
  store float %39, float addrspace(1)* %47, align 4
  ret void
}

declare i64 @_Z13get_global_idj(i32)

!opencl.kernels = !{!0}
!opencl.compiler.options = !{!7}
!opencl.enable.FP_CONTRACT = !{}

!0 = metadata !{void (i32, float addrspace(1)*, float addrspace(1)*, float addrspace(1)*)* @mmult_v1, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 1, i32 1, i32 1}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"float*", metadata !"float*", metadata !"float*"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"int", metadata !"float*", metadata !"float*", metadata !"float*"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"N", metadata !"A", metadata !"B", metadata !"C"}
!7 = metadata !{metadata !"-cl-std=CL1.2", metadata !"-cl-kernel-arg-info"}

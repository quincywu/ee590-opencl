; ModuleID = 'C:\Users\quincywu\AppData\Local\Temp\2300ac04-5d0f-430d-ad79-577354486def.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f80:128:128-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-f80:128:128-n8:16:32:64"
target triple = "igil_64_GEN9"

define void @elementwiseMatrixPower(float addrspace(1)* %inputA, i32 %Kpower, float addrspace(1)* %outputB) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca i32, align 4
  %3 = alloca float addrspace(1)*, align 8
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %width = alloca i32, align 4
  %height = alloca i32, align 4
  %id = alloca i32, align 4
  store float addrspace(1)* %inputA, float addrspace(1)** %1, align 8
  store i32 %Kpower, i32* %2, align 4
  store float addrspace(1)* %outputB, float addrspace(1)** %3, align 8
  %4 = call i64 @_Z13get_global_idj(i32 0)
  %5 = trunc i64 %4 to i32
  store i32 %5, i32* %x, align 4
  %6 = call i64 @_Z13get_global_idj(i32 1)
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %y, align 4
  %8 = call i64 @_Z15get_global_sizej(i32 0)
  %9 = trunc i64 %8 to i32
  store i32 %9, i32* %width, align 4
  %10 = call i64 @_Z15get_global_sizej(i32 1)
  %11 = trunc i64 %10 to i32
  store i32 %11, i32* %height, align 4
  %12 = load i32* %y, align 4
  %13 = load i32* %width, align 4
  %14 = mul nsw i32 %12, %13
  %15 = load i32* %x, align 4
  %16 = add nsw i32 %14, %15
  store i32 %16, i32* %id, align 4
  %17 = load i32* %id, align 4
  %18 = sext i32 %17 to i64
  %19 = load float addrspace(1)** %1, align 8
  %20 = getelementptr inbounds float addrspace(1)* %19, i64 %18
  %21 = load float addrspace(1)* %20, align 4
  %22 = load i32* %2, align 4
  %23 = sitofp i32 %22 to float
  %24 = call float @_Z3powff(float %21, float %23)
  %25 = load i32* %id, align 4
  %26 = sext i32 %25 to i64
  %27 = load float addrspace(1)** %3, align 8
  %28 = getelementptr inbounds float addrspace(1)* %27, i64 %26
  store float %24, float addrspace(1)* %28, align 4
  ret void
}

declare i64 @_Z13get_global_idj(i32)

declare i64 @_Z15get_global_sizej(i32)

declare float @_Z3powff(float, float)

define void @progressiveArraySum(float addrspace(1)* %inputA, float addrspace(1)* %outputB) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %x = alloca i32, align 4
  %id = alloca i32, align 4
  %tmp = alloca float, align 4
  %i = alloca i32, align 4
  store float addrspace(1)* %inputA, float addrspace(1)** %1, align 8
  store float addrspace(1)* %outputB, float addrspace(1)** %2, align 8
  %3 = call i64 @_Z13get_global_idj(i32 0)
  %4 = trunc i64 %3 to i32
  store i32 %4, i32* %x, align 4
  %5 = load i32* %x, align 4
  store i32 %5, i32* %id, align 4
  store float 0.000000e+00, float* %tmp, align 4
  store i32 0, i32* %i, align 4
  br label %6

; <label>:6                                       ; preds = %18, %0
  %7 = load i32* %i, align 4
  %8 = load i32* %id, align 4
  %9 = icmp ult i32 %7, %8
  br i1 %9, label %10, label %21

; <label>:10                                      ; preds = %6
  %11 = load i32* %i, align 4
  %12 = zext i32 %11 to i64
  %13 = load float addrspace(1)** %1, align 8
  %14 = getelementptr inbounds float addrspace(1)* %13, i64 %12
  %15 = load float addrspace(1)* %14, align 4
  %16 = load float* %tmp, align 4
  %17 = fadd float %16, %15
  store float %17, float* %tmp, align 4
  br label %18

; <label>:18                                      ; preds = %10
  %19 = load i32* %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, i32* %i, align 4
  br label %6

; <label>:21                                      ; preds = %6
  %22 = load float* %tmp, align 4
  %23 = load i32* %id, align 4
  %24 = sext i32 %23 to i64
  %25 = load float addrspace(1)** %1, align 8
  %26 = getelementptr inbounds float addrspace(1)* %25, i64 %24
  %27 = load float addrspace(1)* %26, align 4
  %28 = fadd float %22, %27
  %29 = load i32* %id, align 4
  %30 = sext i32 %29 to i64
  %31 = load float addrspace(1)** %2, align 8
  %32 = getelementptr inbounds float addrspace(1)* %31, i64 %30
  store float %28, float addrspace(1)* %32, align 4
  ret void
}

!opencl.kernels = !{!0, !7}
!opencl.compiler.options = !{!14}
!opencl.enable.FP_CONTRACT = !{}

!0 = metadata !{void (float addrspace(1)*, i32, float addrspace(1)*)* @elementwiseMatrixPower, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0, i32 1}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"float*", metadata !"int", metadata !"float*"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"float*", metadata !"int", metadata !"float*"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"inputA", metadata !"Kpower", metadata !"outputB"}
!7 = metadata !{void (float addrspace(1)*, float addrspace(1)*)* @progressiveArraySum, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !13}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"float*", metadata !"float*"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!12 = metadata !{metadata !"kernel_arg_base_type", metadata !"float*", metadata !"float*"}
!13 = metadata !{metadata !"kernel_arg_name", metadata !"inputA", metadata !"outputB"}
!14 = metadata !{metadata !"-cl-std=CL1.2", metadata !"-cl-kernel-arg-info"}

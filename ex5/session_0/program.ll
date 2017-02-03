; ModuleID = 'C:\Users\quincywu\AppData\Local\Temp\501bf1d2-d466-4746-802b-67d17acad0a0.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f16:16:16-f32:32:32-f64:64:64-f80:128:128-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-f80:128:128-n8:16:32:64"
target triple = "igil_64_GEN9"

@reduce_v1.sdata = internal addrspace(3) global [8 x float] zeroinitializer, align 4
@reduce_v2.sdata = internal addrspace(3) global [8 x float] zeroinitializer, align 4
@reduce_v3.sdata = internal addrspace(3) global [8 x float] zeroinitializer, align 4
@inclusive_scan_v1.XY = internal addrspace(3) global [8 x float] zeroinitializer, align 4

define void @reduce_v1(float addrspace(1)* %g_indata, float addrspace(1)* %g_outdata) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %gid = alloca i32, align 4
  %lid = alloca i32, align 4
  %s = alloca i32, align 4
  store float addrspace(1)* %g_indata, float addrspace(1)** %1, align 8
  store float addrspace(1)* %g_outdata, float addrspace(1)** %2, align 8
  %3 = call i64 @_Z13get_global_idj(i32 0)
  %4 = trunc i64 %3 to i32
  store i32 %4, i32* %gid, align 4
  %5 = call i64 @_Z12get_local_idj(i32 0)
  %6 = trunc i64 %5 to i32
  store i32 %6, i32* %lid, align 4
  %7 = load i32* %gid, align 4
  %8 = sext i32 %7 to i64
  %9 = load float addrspace(1)** %1, align 8
  %10 = getelementptr inbounds float addrspace(1)* %9, i64 %8
  %11 = load float addrspace(1)* %10, align 4
  %12 = load i32* %lid, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v1.sdata, i32 0, i64 %13
  store float %11, float addrspace(3)* %14, align 4
  call void @_Z18work_group_barrierj(i32 1)
  store i32 1, i32* %s, align 4
  br label %15

; <label>:15                                      ; preds = %37, %0
  %16 = load i32* %s, align 4
  %17 = icmp ult i32 %16, 8
  br i1 %17, label %18, label %40

; <label>:18                                      ; preds = %15
  %19 = load i32* %lid, align 4
  %20 = load i32* %s, align 4
  %21 = mul i32 2, %20
  %22 = urem i32 %19, %21
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %36

; <label>:24                                      ; preds = %18
  %25 = load i32* %lid, align 4
  %26 = load i32* %s, align 4
  %27 = add i32 %25, %26
  %28 = zext i32 %27 to i64
  %29 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v1.sdata, i32 0, i64 %28
  %30 = load float addrspace(3)* %29, align 4
  %31 = load i32* %lid, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v1.sdata, i32 0, i64 %32
  %34 = load float addrspace(3)* %33, align 4
  %35 = fadd float %34, %30
  store float %35, float addrspace(3)* %33, align 4
  br label %36

; <label>:36                                      ; preds = %24, %18
  call void @_Z18work_group_barrierj(i32 1)
  br label %37

; <label>:37                                      ; preds = %36
  %38 = load i32* %s, align 4
  %39 = mul i32 %38, 2
  store i32 %39, i32* %s, align 4
  br label %15

; <label>:40                                      ; preds = %15
  %41 = load i32* %lid, align 4
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %43, label %48

; <label>:43                                      ; preds = %40
  %44 = load float addrspace(3)* getelementptr inbounds ([8 x float] addrspace(3)* @reduce_v1.sdata, i32 0, i64 0), align 4
  %45 = call i64 @_Z12get_group_idj(i32 0)
  %46 = load float addrspace(1)** %2, align 8
  %47 = getelementptr inbounds float addrspace(1)* %46, i64 %45
  store float %44, float addrspace(1)* %47, align 4
  br label %48

; <label>:48                                      ; preds = %43, %40
  ret void
}

declare i64 @_Z13get_global_idj(i32)

declare i64 @_Z12get_local_idj(i32)

declare void @_Z18work_group_barrierj(i32)

declare i64 @_Z12get_group_idj(i32)

define void @reduce_v2(float addrspace(1)* %g_indata, float addrspace(1)* %g_outdata) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %gid = alloca i32, align 4
  %lid = alloca i32, align 4
  %s = alloca i32, align 4
  %index = alloca i32, align 4
  store float addrspace(1)* %g_indata, float addrspace(1)** %1, align 8
  store float addrspace(1)* %g_outdata, float addrspace(1)** %2, align 8
  %3 = call i64 @_Z13get_global_idj(i32 0)
  %4 = trunc i64 %3 to i32
  store i32 %4, i32* %gid, align 4
  %5 = call i64 @_Z12get_local_idj(i32 0)
  %6 = trunc i64 %5 to i32
  store i32 %6, i32* %lid, align 4
  %7 = load i32* %gid, align 4
  %8 = sext i32 %7 to i64
  %9 = load float addrspace(1)** %1, align 8
  %10 = getelementptr inbounds float addrspace(1)* %9, i64 %8
  %11 = load float addrspace(1)* %10, align 4
  %12 = load i32* %lid, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v2.sdata, i32 0, i64 %13
  store float %11, float addrspace(3)* %14, align 4
  call void @_Z18work_group_barrierj(i32 1)
  store i32 1, i32* %s, align 4
  br label %15

; <label>:15                                      ; preds = %38, %0
  %16 = load i32* %s, align 4
  %17 = icmp ult i32 %16, 3
  br i1 %17, label %18, label %41

; <label>:18                                      ; preds = %15
  %19 = load i32* %s, align 4
  %20 = mul i32 2, %19
  %21 = load i32* %lid, align 4
  %22 = mul i32 %20, %21
  store i32 %22, i32* %index, align 4
  %23 = load i32* %index, align 4
  %24 = icmp slt i32 %23, 8
  br i1 %24, label %25, label %37

; <label>:25                                      ; preds = %18
  %26 = load i32* %index, align 4
  %27 = load i32* %s, align 4
  %28 = add i32 %26, %27
  %29 = zext i32 %28 to i64
  %30 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v2.sdata, i32 0, i64 %29
  %31 = load float addrspace(3)* %30, align 4
  %32 = load i32* %index, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v2.sdata, i32 0, i64 %33
  %35 = load float addrspace(3)* %34, align 4
  %36 = fadd float %35, %31
  store float %36, float addrspace(3)* %34, align 4
  br label %37

; <label>:37                                      ; preds = %25, %18
  call void @_Z18work_group_barrierj(i32 1)
  br label %38

; <label>:38                                      ; preds = %37
  %39 = load i32* %s, align 4
  %40 = mul i32 %39, 2
  store i32 %40, i32* %s, align 4
  br label %15

; <label>:41                                      ; preds = %15
  %42 = load i32* %lid, align 4
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %44, label %49

; <label>:44                                      ; preds = %41
  %45 = load float addrspace(3)* getelementptr inbounds ([8 x float] addrspace(3)* @reduce_v2.sdata, i32 0, i64 0), align 4
  %46 = call i64 @_Z12get_group_idj(i32 0)
  %47 = load float addrspace(1)** %2, align 8
  %48 = getelementptr inbounds float addrspace(1)* %47, i64 %46
  store float %45, float addrspace(1)* %48, align 4
  br label %49

; <label>:49                                      ; preds = %44, %41
  ret void
}

define void @reduce_v3(float addrspace(1)* %g_indata, float addrspace(1)* %g_outdata) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %gid = alloca i32, align 4
  %lid = alloca i32, align 4
  %s = alloca i32, align 4
  store float addrspace(1)* %g_indata, float addrspace(1)** %1, align 8
  store float addrspace(1)* %g_outdata, float addrspace(1)** %2, align 8
  %3 = call i64 @_Z13get_global_idj(i32 0)
  %4 = trunc i64 %3 to i32
  store i32 %4, i32* %gid, align 4
  %5 = call i64 @_Z12get_local_idj(i32 0)
  %6 = trunc i64 %5 to i32
  store i32 %6, i32* %lid, align 4
  %7 = load i32* %gid, align 4
  %8 = sext i32 %7 to i64
  %9 = load float addrspace(1)** %1, align 8
  %10 = getelementptr inbounds float addrspace(1)* %9, i64 %8
  %11 = load float addrspace(1)* %10, align 4
  %12 = load i32* %lid, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v3.sdata, i32 0, i64 %13
  store float %11, float addrspace(3)* %14, align 4
  call void @_Z18work_group_barrierj(i32 1)
  %15 = call i64 @_Z14get_local_sizej(i32 0)
  %16 = trunc i64 %15 to i32
  store i32 %16, i32* %s, align 4
  br label %17

; <label>:17                                      ; preds = %37, %0
  %18 = load i32* %s, align 4
  %19 = icmp uge i32 %18, 1
  br i1 %19, label %20, label %40

; <label>:20                                      ; preds = %17
  %21 = load i32* %lid, align 4
  %22 = load i32* %s, align 4
  %23 = icmp ult i32 %21, %22
  br i1 %23, label %24, label %36

; <label>:24                                      ; preds = %20
  %25 = load i32* %lid, align 4
  %26 = load i32* %s, align 4
  %27 = add i32 %25, %26
  %28 = zext i32 %27 to i64
  %29 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v3.sdata, i32 0, i64 %28
  %30 = load float addrspace(3)* %29, align 4
  %31 = load i32* %lid, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [8 x float] addrspace(3)* @reduce_v3.sdata, i32 0, i64 %32
  %34 = load float addrspace(3)* %33, align 4
  %35 = fadd float %34, %30
  store float %35, float addrspace(3)* %33, align 4
  br label %36

; <label>:36                                      ; preds = %24, %20
  br label %37

; <label>:37                                      ; preds = %36
  %38 = load i32* %s, align 4
  %39 = udiv i32 %38, 2
  store i32 %39, i32* %s, align 4
  br label %17

; <label>:40                                      ; preds = %17
  %41 = load i32* %lid, align 4
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %43, label %48

; <label>:43                                      ; preds = %40
  %44 = load float addrspace(3)* getelementptr inbounds ([8 x float] addrspace(3)* @reduce_v3.sdata, i32 0, i64 0), align 4
  %45 = call i64 @_Z12get_group_idj(i32 0)
  %46 = load float addrspace(1)** %2, align 8
  %47 = getelementptr inbounds float addrspace(1)* %46, i64 %45
  store float %44, float addrspace(1)* %47, align 4
  br label %48

; <label>:48                                      ; preds = %43, %40
  ret void
}

declare i64 @_Z14get_local_sizej(i32)

define void @inclusive_scan_v1(float addrspace(1)* %X, float addrspace(1)* %Y, i32 %InputSize) {
  %1 = alloca float addrspace(1)*, align 8
  %2 = alloca float addrspace(1)*, align 8
  %3 = alloca i32, align 4
  %gid = alloca i32, align 4
  %lid = alloca i32, align 4
  %stride = alloca i32, align 4
  store float addrspace(1)* %X, float addrspace(1)** %1, align 8
  store float addrspace(1)* %Y, float addrspace(1)** %2, align 8
  store i32 %InputSize, i32* %3, align 4
  %4 = call i64 @_Z13get_global_idj(i32 0)
  %5 = trunc i64 %4 to i32
  store i32 %5, i32* %gid, align 4
  %6 = call i64 @_Z12get_local_idj(i32 0)
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %lid, align 4
  %8 = load i32* %gid, align 4
  %9 = load i32* %3, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %20

; <label>:11                                      ; preds = %0
  %12 = load i32* %gid, align 4
  %13 = sext i32 %12 to i64
  %14 = load float addrspace(1)** %1, align 8
  %15 = getelementptr inbounds float addrspace(1)* %14, i64 %13
  %16 = load float addrspace(1)* %15, align 4
  %17 = load i32* %lid, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds [8 x float] addrspace(3)* @inclusive_scan_v1.XY, i32 0, i64 %18
  store float %16, float addrspace(3)* %19, align 4
  br label %20

; <label>:20                                      ; preds = %11, %0
  store i32 1, i32* %stride, align 4
  br label %21

; <label>:21                                      ; preds = %37, %20
  %22 = load i32* %stride, align 4
  %23 = load i32* %lid, align 4
  %24 = icmp ule i32 %22, %23
  br i1 %24, label %25, label %40

; <label>:25                                      ; preds = %21
  call void @_Z18work_group_barrierj(i32 1)
  %26 = load i32* %lid, align 4
  %27 = load i32* %stride, align 4
  %28 = sub i32 %26, %27
  %29 = zext i32 %28 to i64
  %30 = getelementptr inbounds [8 x float] addrspace(3)* @inclusive_scan_v1.XY, i32 0, i64 %29
  %31 = load float addrspace(3)* %30, align 4
  %32 = load i32* %lid, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [8 x float] addrspace(3)* @inclusive_scan_v1.XY, i32 0, i64 %33
  %35 = load float addrspace(3)* %34, align 4
  %36 = fadd float %35, %31
  store float %36, float addrspace(3)* %34, align 4
  br label %37

; <label>:37                                      ; preds = %25
  %38 = load i32* %stride, align 4
  %39 = mul i32 %38, 2
  store i32 %39, i32* %stride, align 4
  br label %21

; <label>:40                                      ; preds = %21
  %41 = load i32* %lid, align 4
  %42 = sext i32 %41 to i64
  %43 = getelementptr inbounds [8 x float] addrspace(3)* @inclusive_scan_v1.XY, i32 0, i64 %42
  %44 = load float addrspace(3)* %43, align 4
  %45 = load i32* %gid, align 4
  %46 = sext i32 %45 to i64
  %47 = load float addrspace(1)** %2, align 8
  %48 = getelementptr inbounds float addrspace(1)* %47, i64 %46
  store float %44, float addrspace(1)* %48, align 4
  ret void
}

!opencl.kernels = !{!0, !7, !8, !9}
!opencl.compiler.options = !{!16}
!opencl.enable.FP_CONTRACT = !{}

!0 = metadata !{void (float addrspace(1)*, float addrspace(1)*)* @reduce_v1, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"float*", metadata !"float*"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"float*", metadata !"float*"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"g_indata", metadata !"g_outdata"}
!7 = metadata !{void (float addrspace(1)*, float addrspace(1)*)* @reduce_v2, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!8 = metadata !{void (float addrspace(1)*, float addrspace(1)*)* @reduce_v3, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!9 = metadata !{void (float addrspace(1)*, float addrspace(1)*, i32)* @inclusive_scan_v1, metadata !10, metadata !11, metadata !12, metadata !13, metadata !14, metadata !15}
!10 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0}
!11 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!12 = metadata !{metadata !"kernel_arg_type", metadata !"float*", metadata !"float*", metadata !"int"}
!13 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!14 = metadata !{metadata !"kernel_arg_base_type", metadata !"float*", metadata !"float*", metadata !"int"}
!15 = metadata !{metadata !"kernel_arg_name", metadata !"X", metadata !"Y", metadata !"InputSize"}
!16 = metadata !{metadata !"-cl-std=CL2.0", metadata !"-cl-kernel-arg-info"}

; ModuleID = 'C:/Users/quincywu/Documents/Intel/CodeBuilderSessions/ex3a_mmult/program.cl'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir64-unknown-unknown"

define cc76 void @mmult_v1(i32 %N, float addrspace(1)* nocapture %A, float addrspace(1)* nocapture %B, float addrspace(1)* nocapture %C) nounwind {
  %1 = tail call cc75 i64 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = trunc i64 %1 to i32
  %3 = tail call cc75 i64 @_Z13get_global_idj(i32 1) nounwind readnone
  %4 = trunc i64 %3 to i32
  %5 = icmp sgt i32 %N, 0
  %6 = mul nsw i32 %2, %N
  br i1 %5, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0, %.lr.ph
  %tem.014 = phi float [ %17, %.lr.ph ], [ 0.000000e+00, %0 ]
  %k.013 = phi i32 [ %18, %.lr.ph ], [ 0, %0 ]
  %7 = add nsw i32 %k.013, %6
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds float addrspace(1)* %A, i64 %8
  %10 = load float addrspace(1)* %9, align 4, !tbaa !9
  %11 = mul nsw i32 %k.013, %N
  %12 = add nsw i32 %11, %4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds float addrspace(1)* %B, i64 %13
  %15 = load float addrspace(1)* %14, align 4, !tbaa !9
  %16 = fmul float %10, %15
  %17 = fadd float %tem.014, %16
  %18 = add nsw i32 %k.013, 1
  %19 = icmp slt i32 %18, %N
  br i1 %19, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %0
  %tem.0.lcssa = phi float [ 0.000000e+00, %0 ], [ %17, %.lr.ph ]
  %20 = add nsw i32 %6, %4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds float addrspace(1)* %C, i64 %21
  store float %tem.0.lcssa, float addrspace(1)* %22, align 4, !tbaa !9
  ret void
}

declare cc75 i64 @_Z13get_global_idj(i32) nounwind readnone

!opencl.kernels = !{!0}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!7}
!opencl.ocl.version = !{!7}
!opencl.used.extensions = !{!8}
!opencl.used.optional.core.features = !{!8}
!opencl.compiler.options = !{!8}

!0 = metadata !{void (i32, float addrspace(1)*, float addrspace(1)*, float addrspace(1)*)* @mmult_v1, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 1, i32 1, i32 1}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"float*", metadata !"float*", metadata !"float*"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_base_type", metadata !"int", metadata !"float*", metadata !"float*", metadata !"float*"}
!6 = metadata !{metadata !"kernel_arg_name", metadata !"N", metadata !"A", metadata !"B", metadata !"C"}
!7 = metadata !{i32 1, i32 2}
!8 = metadata !{}
!9 = metadata !{metadata !"float", metadata !10}
!10 = metadata !{metadata !"omnipotent char", metadata !11}
!11 = metadata !{metadata !"Simple C/C++ TBAA"}

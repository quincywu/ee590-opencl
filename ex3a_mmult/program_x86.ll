; ModuleID = 'C:/Users/quincywu/Documents/Intel/CodeBuilderSessions/ex3a_mmult/program.cl'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir-unknown-unknown"

define cc76 void @mmult_v1(i32 %N, float addrspace(1)* nocapture %A, float addrspace(1)* nocapture %B, float addrspace(1)* nocapture %C) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = tail call cc75 i32 @_Z13get_global_idj(i32 1) nounwind readnone
  %3 = icmp sgt i32 %N, 0
  %4 = mul nsw i32 %1, %N
  br i1 %3, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0, %.lr.ph
  %tem.014 = phi float [ %13, %.lr.ph ], [ 0.000000e+00, %0 ]
  %k.013 = phi i32 [ %14, %.lr.ph ], [ 0, %0 ]
  %5 = add nsw i32 %k.013, %4
  %6 = getelementptr inbounds float addrspace(1)* %A, i32 %5
  %7 = load float addrspace(1)* %6, align 4, !tbaa !9
  %8 = mul nsw i32 %k.013, %N
  %9 = add nsw i32 %8, %2
  %10 = getelementptr inbounds float addrspace(1)* %B, i32 %9
  %11 = load float addrspace(1)* %10, align 4, !tbaa !9
  %12 = fmul float %7, %11
  %13 = fadd float %tem.014, %12
  %14 = add nsw i32 %k.013, 1
  %15 = icmp slt i32 %14, %N
  br i1 %15, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %0
  %tem.0.lcssa = phi float [ 0.000000e+00, %0 ], [ %13, %.lr.ph ]
  %16 = add nsw i32 %4, %2
  %17 = getelementptr inbounds float addrspace(1)* %C, i32 %16
  store float %tem.0.lcssa, float addrspace(1)* %17, align 4, !tbaa !9
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

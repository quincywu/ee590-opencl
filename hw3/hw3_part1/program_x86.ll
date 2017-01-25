; ModuleID = 'C:/Users/quincywu/Documents/GitHub/ee590-opencl/hw3/hw3_part1/program.cl'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir-unknown-unknown"

define cc76 void @elementwiseMatrixPower(float addrspace(1)* nocapture %inputA, i32 %Kpower, float addrspace(1)* nocapture %outputB) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = tail call cc75 i32 @_Z13get_global_idj(i32 1) nounwind readnone
  %3 = tail call cc75 i32 @_Z15get_global_sizej(i32 0) nounwind readnone
  %4 = mul nsw i32 %3, %2
  %5 = add nsw i32 %4, %1
  %6 = getelementptr inbounds float addrspace(1)* %inputA, i32 %5
  %7 = load float addrspace(1)* %6, align 4, !tbaa !16
  %8 = sitofp i32 %Kpower to float
  %9 = tail call cc75 float @_Z3powff(float %7, float %8) nounwind readnone
  %10 = getelementptr inbounds float addrspace(1)* %outputB, i32 %5
  store float %9, float addrspace(1)* %10, align 4, !tbaa !16
  ret void
}

declare cc75 i32 @_Z13get_global_idj(i32) nounwind readnone

declare cc75 i32 @_Z15get_global_sizej(i32) nounwind readnone

declare cc75 float @_Z3powff(float, float) nounwind readnone

define cc76 void @progressiveArraySum(float addrspace(1)* nocapture %inputA, float addrspace(1)* nocapture %outputB) nounwind {
  %1 = tail call cc75 i32 @_Z13get_global_idj(i32 0) nounwind readnone
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %0, %.lr.ph
  %i.09 = phi i32 [ %6, %.lr.ph ], [ 0, %0 ]
  %tmp.08 = phi float [ %5, %.lr.ph ], [ 0.000000e+00, %0 ]
  %3 = getelementptr inbounds float addrspace(1)* %inputA, i32 %i.09
  %4 = load float addrspace(1)* %3, align 4, !tbaa !16
  %5 = fadd float %tmp.08, %4
  %6 = add i32 %i.09, 1
  %7 = icmp ult i32 %6, %1
  br i1 %7, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %0
  %tmp.0.lcssa = phi float [ 0.000000e+00, %0 ], [ %5, %.lr.ph ]
  %8 = getelementptr inbounds float addrspace(1)* %inputA, i32 %1
  %9 = load float addrspace(1)* %8, align 4, !tbaa !16
  %10 = fadd float %tmp.0.lcssa, %9
  %11 = getelementptr inbounds float addrspace(1)* %outputB, i32 %1
  store float %10, float addrspace(1)* %11, align 4, !tbaa !16
  ret void
}

!opencl.kernels = !{!0, !7}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!14}
!opencl.ocl.version = !{!14}
!opencl.used.extensions = !{!15}
!opencl.used.optional.core.features = !{!15}
!opencl.compiler.options = !{!15}

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
!14 = metadata !{i32 1, i32 2}
!15 = metadata !{}
!16 = metadata !{metadata !"float", metadata !17}
!17 = metadata !{metadata !"omnipotent char", metadata !18}
!18 = metadata !{metadata !"Simple C/C++ TBAA"}

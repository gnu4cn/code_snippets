# 高性能/并行计算方面

[并行计算介绍，劳伦斯利弗莫尔国家实验室](https://hpc.llnl.gov/documentation/tutorials/introduction-parallel-computing-tutorial) 对并行计算有较详细介绍，主要用于科学与工程领域，包括：

- 大气科学、地球科学、环境科学等；
- 物理学 -- 应用物理学、核物理、粒子物理、凝聚态物质科学、高压、聚变、光子学；
- 生物科学、生物技术、基因科学；
- 化学、分子科学；
- 地质科学、地震科学；
- 机械工程 -- 从义肢到航天飞机；
- 电子工程、电路设计、微电子；
- 计算机科学、数学；
- 防务、武器设计。

并行计算主要用到消息传递接口标准，Message Passing Interface, MPI，开放实现为 [OpenMPI](https://www.open-mpi.org/)，达到多机并行计算时相互之间通信目的。此外，随着 GPGPU、ASIC 与 FPGA 计算的出现和发展成熟，高性能计算呈现异构、混合形态，参考 [HPC 编程模型、编译器，性能分析](https://hpc-lr.umontpellier.fr/wp-content/uploads/2017/02/5_HPC_SystemArchitecture_ProgrammingModels_Compilers.pdf)。

## `Environment Modules` 工具

[IBM LSF](https://en.wikipedia.org/wiki/IBM_Spectrum_LSF) 与 [Open MPI](https://www.open-mpi.org/) 都要用到这个 [Environment Modules 工具](https://modules.readthedocs.io/en/latest/)。本小节将介绍此工具原理与用法。

在 ArchLinux 系统（Manjaro）上安装 Environment Modules：

```console
$ yay -S env-modules
```

# 业务流程管理系统概况与选型
## The situation and options in BPM system


作为我入职一开始，Ryan 给我安排的一项中长期任务，即按照公司发展现状，部署一套适合的办公自动化系统。Ryan先后提出多个目标：1、可以实现请假、报销等公司日常管理的无纸化；2、按照公司目前规模及公司领导决策，暂时在这个系统上没有财务支出的计划，Ryan考虑采用开源软件；3、该系统要考虑未来与公司ERP系统的集成/迁移，此外Ryan还具体提出了其他如预选型的系统，需要具备国内技术支持团队等意见。我根据Ryan提出的要求，对这样的系统在国内、国际的情况进行了解，并针对其中多个实地安装和测试，得出一些结论，现予以记录和报告。不妥之处，敬请谅解。

As a mid-to-long term task arranged by Ryan to me after I got in our company, to deploy an OA/BPM system according the current scale of our company, it should be suitable and efficiency to our core business and current scale. Ryan gave several specific targets to me successively. These targets including: 

1. The system should transfer the daily administrative affairs like stuff leave application, reimbursement, purchase requisition and other processes to online/paperless operations; 

2. According to the current scale and company heads' decision, there's no budget to support the OA/BPM system building, so Ryan pointed that the open source solution should be the choice; 

3. The candidate system should be easy to integrate with or migrate to the future company ERP. 

Ryan also gave me some other instructions like that the candidate system should have local tech support teams, and when our company decide to pay for the commercial support, we can hire them to support the system. With these instructions, in the last few weeks, I studied the BPM system industry both in China and other area, downloaded and tested several commercial and open source solutions, and after that, I got some knowledge about the BPM system and this industry, now this report is shaped. Please forget the shortages of this report.


## 一、术语解释, The Terms


下面是相关术语及其引用来源，仅供参考。其中 BPMN 是行业的公开标准，被众多 BPM 软件系统所采纳。

The following list are some terms and their references, provided here for your understanding and reference. For the BPMN is the standards of the BPM software industry, be used and implemented in many BPM solutions.


### 1. 业务流程管理，Business Process Management, BPM


> “业务流程管理或商业流程管理（英语：Business Process Management，简称BPM），是自本世纪初以来企业信息技术应用（信息化）背景上最重要和活跃的概念之一。它有两方面的基本含义或理解背景。一方面是企业管理，一方面是信息技术的企业应用。综合而言，它是典型的，在企业应用强力推动下产生的跨管理与信息技术领域的流行概念之一。
>
> 业务流程管理着重在识别出一连串的商业管理活动，并针对这些活动的作业流程进行管理的动作。其目标在透过各种科学的方法，来确保企业中各种商业活动的执行成果能具有一定的水准和精确度，同时也能持续改善活动的进行方式，串连活动的作业流程，让企业能保持市场上的竞争力。
>
> 从管理的角度，它可以看作是企业流程再造（BPR）所带来的以商业流程为中心的管理思想的延续与发展；从企业应用角度，它是在工作流（Workflow）等技术基础上发展起来的，基于业务流程建模，支持业务流程的分析、建模、模拟、优化、协同与监控等功能的新一代企业应用系统核心。与商业流程管理系统相关主要领域包括流程梳理与诊断、流程建模与运行管理、流程监控、分析与改进以及流程化业务领域应用。”

<p align="right">-- <i><a href="https://zh.wikipedia.org/wiki/业务流程管理">zh.wikipedia.org/wiki/业务流程管理</a></i></p>



> "Business process management (BPM) is the discipline in which people use various methods to discover, model, analyze, measure, improve, optimize, and automate business processes."

<p align="right">-- <i><a href="https://en.wikipedia.org/wiki/Business_process_management">en.wikipedia/wiki/Business_process_management</a></i></p>



### 2. 业务流程模型和标记法，Business Process Model and Notation, BPMN

> “业务流程模型和标记法（BPMN, Business Process Model and Notation）是一套图形化表示法，用于以业务流程模型详细说明各种业务流程。”

<p align="right">-- <i><a href="https://zh.wikipedia.org/wiki/业务流程模型和标记法">zh.wikipedia.org/wiki/业务流程模型和标记法</a></i></p>


> "Business Process Model and Notation (BPMN) is a graphical representation for specifying business processes in a business process model."

<p align="right">-- <i><a href="https://en.wikipedia.org/wiki/Business_Process_Model_and_Notation">en.wikipedia.org/wiki/Business_Process_Model_and_Notation</a></i></p>


> "Business Process Model and Notation has become the de-facto standard for business processes diagrams. It is intended to be used directly by the stakeholders who design, manage and realize business processes, but at the same time be precise enough to allow BPMN diagrams to be translated into software process components. BPMN has an easy-to-use flowchart-like notation that is independent of any particular implementation environment."


<p align="right">-- <i><a href="https://www.omg.org/spec/BPMN/2.0/">www.omg.org/spec/BPMN/2.0/</a></i></p>


## 二、下载和测试过的软件，Softwares and Solutions tested

从我接受这项任务以来，就经由搜索引擎与实际接触有关开展此类业务的软件公司，展开了有关办公自动化/业务流程管理系统的调研与实际软件安装测试，先后了解、测试过 Ccflow，Django-viewflow, O2OA，Joget，Activiti等 BPM 软件/方案等。下面是这些软件的大致情况。

From the beginning of my job on this task, I studied the current BPM industry roughly and tested several solutions through the search engines, knowledge sites and contact directly with some BPM solution providers. These tested frameworks/softwares/solutions including: Ccflow, Djang-viewflow, O2OA, Joget, Activiti. The following table is the things about them.

| 名字<br />Name | 许可证<br />License | 网站<br />Website | 本地支持<br />Local support | 与现有IT设施集成难度<br />Difficulty to integrate with current IT infrastructure | BPMN兼容性<br />BPMN ready | 需要开发<br />Need coding |
| :-: | :-- | :-- | :-: | :-- | :-- | :-- |
| Ccflow | 代码开源，商业支持<br />Opensource, with commercial support | [ccflow.org](http://ccflow.org)（官网，Offcial website）<br />[Demo website](http://help.jflow.cn:8081/WF/Portal/Login.htm) | 国内团队<br />Chinese team | 难（无商业支持情况下） <br />Hard(without commercial support) | 不兼容<br />No | 商业支持下不需要<br />Not(with commercial support) |
| Django-viewflow | Opensource | [viewflow.io](http://viewflow.io/)<br />[viewflow/viewflow](https://github.com/viewflow/viewflow)<br /> | 无本地支持<br />No | 易于集成<br /> Easy | 兼容<br />Yes | 需要<br /> Heavy coding needed |
| O2OA | 代码开源，商业支持<br />Opensource, with commercial support | [o2oa.net](https://www.o2oa.net/)（官网，Offcial website）<br /> [Demo website](http://doc.o2oa.net/x_desktop/document.html?app=CloudDocument) | 国内团队<br />Chinese team | 难于集成<br />Hard | 不兼容<br />No | 商业支持下不需要<br />Not(with commercial support) |
| Joget | 区分社区、专业和企业版本<br />Opensource for the community version, for pro and enterprise verion, with commercial support | [joget.org](https://www.joget.org/)（官网，Official website） | 有本地支持（国内代理[joget.cn](https://joget.cn/)）<br />Joget has a Chinese retailer [joget.cn](https://joget.cn/) | 容易（企业版）<br />Easy(for enterprise version) | 兼容<br />Yes | 使用企业版不需要<br />Not(with the enterprise version) |
| Activiti | 开放源代码<br /> Opensource | [activiti.org](https://www.activiti.org/) | 作为老牌BPM系统开源基础组件，国内有支持<br />As the de-facto standard of BPM industry, there are local supports in China | 容易<br /> Easy | 兼容性极好<br />Excellent | 需要开发<br />Coding needed |

> 公司现在的IT基础设施（除研发外），据Ryan给我的知识，是基本基于微软®域控制器、域名服务器等的方案。
>
> As the information from Ryan, the current IT infrastructure of our company(except R&D parts), is base upon MicroSoft® Domain Controller, DNS server and some other solutions.


## 三、最终选项，The available options

综合上面的信息，认为最终有三个选项：

1. 选用成熟框架，自主定制一套OA/BPM系统；

2. 购买商业支持，自主运维一套OA/BPM系统；

3. 购买OA/BPM云服务。

Base on the information provided in the table above, it's clear that we have 3 options. 

- The 1st is that we can choose a mature BPM framework like django-viewflow or Activiti, then do the custom development ourself, and get a qualified BPM system; 

- The 2nd is that we can purchase commercial support from BPM system providers, but hold the system inside our company; 

- The 3rd is that we can purchase the cloud BPM service.

三个选项的比较如下表所示。

The table below is the comparation of these 3 options.

| 选项<br /> Option | 成本<br />Cost | 周期<br />Time | 数据所在<br />Data located |
| :-: | -: | :- | :- |
| 自己开发<br />Developing and operating by ourself | 难于估计<br />Hard-to-estimate | 长，Long | 自有代码，数据在本地<br />We have the code, and data stored locally |
| 商业支持，本地运维<br />Commercial support, but Operated by ourself | 高，High | 短，Short | 自己没有代码，数据在本地<br />No code property, data stored inside our company |
| 购买云服务<br />Purchasing the cloud BPM service | 高, High | 短, Short | 自己没有代码，数据保存在远端<br />No code property, data stored remote |


## 四、愿景，the Vision

我个人认为，在可能的情况下，公司应选择成熟的 BPM 开源框架，进行定制开发，形成一套具有芯片公司特色的BPM软件系统，近期可以自用，远期可以作为软件产品输出。

From my own(Lenny) view, the best choice is that, we can deploy a mature opensource BPM framework, and develop a featured BPM system for chip-designing industry, in short-term the self-developed system can meet our company's needs, and in long-term it can be exported to other chip-designing companies as a product.

但不管做出何种选择，作为公司IT支持人员，都希望获得易于使用、成本合理、数据安全的OA/BPM系统，满足公司急速发展的需要。

But whatever choice is made, as a IT support of our company, I hope we can get a easy-to-use, cost-effective and data-safe OA/BPM system, to meet the needs of our company's fast moving.

# Computer System Final Project

## Phase I: Pipeline CPU Design(simulation)

### Target
完成[MIPS instruction set](https://en.wikipedia.org/wiki/MIPS_instruction_set#MIPS_assembly_language)的所有(??)指令, 第一阶段只进行模拟, 不写在FPGA上.

### Environment
轻量级环境:Sublime + System Verilog Plugin + [iverilog](https://github.com/steveicarus/iverilog) + [gtkwave](http://gtkwave.sourceforge.net/).

为了在sublime上获得更好的自动补全体验, 可以安装[SublimeAllAutocomplete](https://github.com/alienhard/SublimeAllAutocomplete)插件.

#### Installation
* Mac: [如何在Mac OS X上安裝Verilog環境](http://easonchang.logdown.com/posts/649863)
* Win: [Compiling on MS Windows](http://iverilog.wikia.com/wiki/Installation_Guide#Compiling_on_MS_Windows_.28MinGW.29)

Windows版的iverilog在win10+[cygwin](https://www.cygwin.com/)环境下表现良好(需要将cygwin安装目录下的`/usr/local/bin`加入环境变量), 如果make某个文件时遇到了`\r`的问题, 用`dos2unix file`就可以了.

gtkwave在win10的retina屏幕下显示很糟糕, 可以用[这里](http://stackoverflow.com/questions/24768200/how-to-get-emacs-text-to-render-as-crisply-as-netbeans)的方法解决.

#### Usage
编译并运行:
```
iverilog -o CPU CPU.v
vvp CPU
```

显示波形图(需要在`CPU.v`中加上`$dumpfile("CPU.vcd");`并指定`$dumpvars`):
```
gtkwave CPU.vcd
```

gtkwave默认不会显示波形, 需要将变量拖至右侧, 用快捷键`Alt+Z`和`Alt+Shift+Z`可以放大缩小.

### Assembler
GCC-toolchain可以用于构建MIPS指令集的二进制码.

### Design
大部分参考自李亚民资料和Digilent官方资料, 以及雷思磊的《自己动手写CPU》.

具体到每个单元:

#### Pipeline Testbench
每10个时间单元clk取反一次(即一个周期20个时间单元).

```Verilog
module Pipeline_tb;
initial begin
  clk = 1'h0;
  forever #10 clk = ~clk;
end

initial begin
  rst = `RstEnable;
  #195 rst = `RstDisable;
  #1000 $finish;
end

initial begin
  $dumpfile("pipeline.vcd");
  $dumpvars;
end

yourCPU_sopc yourCPU_sopc_0(
  .clk(clk),
  .rst(rst)
  );
endmodule
```

#### SOPC
实例化处理器以及指令储存器(ROM):

```Verilog
yourCPU yourCPU_0(
  .clk(clk),
  .rst(rst),
  .inst_addr(inst_addr),
  .inst_data(inst_data),
  .inst_mem_chip_enable(inst_mem_chip_enable)
  );

inst_mem inst_mem_0(
  .inst_mem_chip_enable(inst_mem_chip_enable),
  .inst_addr(inst_addr),
  .inst_data(inst_data)
  );
```

#### CPU architecture
##### Main architecture:
  * Control Unit
  * Program Counter
  * Instruction Fetch
  * **Intermediate: IF_ID**
  * Instruction Decode
  * Register file
  * **Intermediate: ID_EXE**
  * Arithmetic Logic Unit
  * **Intermediate: EXE_MEM**
  * Data Memory
  * **Intermediate: MEM_WB**

分别介绍每个阶段的接口及内容:
1. Control Unit:`(control_unit.v)`
  * 接口:
    ```Verilog
    module control_unit (
      	input clk,						   // Clock
      	input m_mem_to_reg,				// Mem to Reg in stage MEM
      	input m_write_reg,				// Write Reg in stage MEM
      	input m_des_r,					// Destination Reg in stage MEM
      	input e_des_r,					// Destination Reg in stage EXE
      	input e_write_reg,				// Write Reg in stage EXE
      	input rs_rt_equ,				// rs == rt ?
      	output write_reg,				// Write Reg
      	output mem_to_reg,				// Mem to Reg
      	output write_mem,				// Write Mem
      	output[`ALUBus] aluc,				// ALUcontrol
      	output shift,					// Shift Mul
      	output alu_imm,					// ALU Immediate
      	output sext_signed,			// Sign extension == signed ?
      	output reg_dt,					// Destination Reg == rt?
      	output[`ForwardingBus] fwd_b,	// Forwarding B
      	output[`ForwardingBus] fwd_a,	// Forwarding A
      	output jump,					// Jump Mul
      	output write_pc_ir,				// Write PC & IR
      	output branch					// Branch
    );
    ```
  * 功能:
  控制单元, 同时处理forwarding.

2. Program Counter
  * 接口:
  ```Verilog
  module pc_reg (
      input clk,                //Clock
      input rst,                //Reset
      input[`InstAddrBus] next_addr_i,    //Input address.
      input write_pc_ir           //Write pc & ir, when we need to add a stall, activate it.
      output[`InstAddrBus] pc_o,        //Output address.
  );
  ```
  * 功能:
  给出目前需要执行的指令的地址.

3. Get next address(get_next_addr)
  * 接口
  ```Verilog
  module get_next_addr (
    input clk,                //Clock.
    input branch,             //Branch(from Ctrl_unit)
    input[`InstAddrBus] jump_addr,      //Jump address.
    input[`InstAddrBus] pc,         //Addr from pc_reg.

    output[`InstAddrBus] pc_plus_4,     //pc plus 4.
    output[`InstAddrBus] next_addr_o    //Output next addr.           
  );
  ```
  * 功能:
  给出下一条指令的地址.

4. Instruction Fetch
  * 接口:
  ```Verilog
  module inst_mem (
    input clk,            //Clock
    input ce,           //Chip Enable

    input[`InstAddrBus] addr    //Address
    output[`InstBus] inst       //Instruction
  );
  ```
  * 功能:
  取指令.

5. 


##### Miscellaneous:
  * Sign extension
    (from [stackoverflow](http://stackoverflow.com/questions/4176556/how-to-sign-extend-a-number-in-verilog).)
  ```Verilog
  always @(posedge clk) begin
      extended[15:0] <= {{*{extend[7]}}, extend[7:0]}
  end
  ```
  * Delay Slot(control hazard)
  * Forwarding(data hazard)
  * Register `hi` and `lo`.

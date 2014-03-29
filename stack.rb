VERSION = "0.0.2"

class Stack
	def initialize
		@stack = [] #element with highest index is top of stack, see http://www.ruby-doc.org/core-2.1.1/Array.html#method-i-push and http://www.ruby-doc.org/core-2.1.1/Array.html#method-i-pop
		@loopCommandIndex = []
		@loopIndex = 0 #0 = run once, 1 = run twice, etc...
	end

	def cmd(cmdStr)
		if @loopIndex > 0
			@loopCommandIndex.unshift cmdStr
		end
		cmd = cmdStr.split(" ")
		if cmd[0] == "endl"
			endl
		end
		if @loopIndex == 0 #if we're not in a loop run the commands
			case cmd[0]
			when "push"
				push(cmd[1].to_i)
			when "pop"
				pop

			when "add"
				add
			when "sub"
				sub
			when "mul"
				mul

			when "loop"
				loop(cmd[1].to_i)

			when "prt"
				prt
			when "nprt"
				nprt
			when "pstk"
				pstk

			when "quit"
				exit
			when "help"
				help
			end
		end
	end


	def push(num) #3-4 letter method names
		if num.is_a? Integer
			@stack.push(num)
		end
	end
	def pop
		@stack.pop
	end

	def operation_base #thanks to http://www.reddit.com/r/ruby/comments/21nw0d/small_stack_based_calculator_written_in_ruby/cgf3pwv
		x1 = @stack.pop || 0
		x2 = @stack.pop || 0

		@stack.push yield(x1, x2)
	end
	def add
		operation_base do |x1, x2|
			x1+x2
		end
	end
	def sub
		operation_base do |x1, x2|
			x1-x2
		end
	end
	def mul
		operation_base do |x1, x2|
			x1*x2
		end
	end

	def loop(times) #begin loop
		@loopIndex =+ (times-1)
	end
	def endl #end loop
		puts "> CREATING LOOP"
		@loopCommandIndex.shift
		puts "> #{@loopCommandIndex}"
		@tmpLoopIndex = @loopIndex
		@loopIndex = 0
		(@tmpLoopIndex+1).times do |loopI|
			(0..@loopCommandIndex.length-1).each do |i|
				@loopCommandIndex[i].gsub! "$", loopI.to_s
				cmd(@loopCommandIndex[i])
			end
		end
		@loopCommandIndex = []
	end

	def prt #print
		puts "=> #{@stack.pop}"
	end
	def nprt #print without popping from stack
		puts "=> #{@stack[@stack.length-1]}"
	end
	def pstk #print the stack without popping it
		puts "Top of stack"
		@stack.length.times do |i|
			puts @stack[i]
		end
		puts "Bottom of stack"
	end

	def help
		puts """Stac-man is a pun relating to Pac-man, because that's what I was playing while I made this.
Stac-man is a stack based calculator similar to something like dc or bc. You push numbers onto the stack then perform very simple operations on them.
The commands:

	push x - pushes a number, x, onto the top of the stack
	pop - pops a number off the top of the stack

	add - adds the top two numbers on the stack and puts it on the top
	sub - same with subtraction
	mul - same with multiplication

	loop x - loops the typed commands x number of times (nesting loops doesn't work properly)
	endl - marks the end of a loop

	prt - displays the number on the top of the stack and pops it
	nprt - displays the number on the top of the stack
	pstk - displays the stack"""
	end
end

stackInterface = Stack.new
if !stackInterface.nil?
	puts "Initialized successfully!"
else
	throw "Didn't initialize successfully!"
end
puts "Welcome to the Stac-man Calculator version #{VERSION}"
puts "Type 'quit' to quit or type 'help' to explore the features."

while true
	inputText = gets.chomp
	stackInterface.cmd inputText
end
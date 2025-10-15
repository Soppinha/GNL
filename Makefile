NAME		= get_next_line.a

CC			= cc
CFLAGS		= -Wall -Wextra -Werror

SRC			= get_next_line.c \
			  get_next_line_utils.c

OBJ			= $(SRC:.c=.o)

all: $(NAME)

$(NAME): $(OBJ)
	@ar rcs $(NAME) $(OBJ)
	@echo "✅ $(NAME) created successfully!"

%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -f $(OBJ)
	@echo "🧹 Object files removed."

fclean: clean
	@rm -f $(NAME)
	@echo "🗑️  Library removed."

re: fclean all

.PHONY: all clean fclean re bonus

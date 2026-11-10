NAME			=	libgnl.a

CC				=	cc
CFLAGS			=	-Wall -Wextra -Werror

SRC_DIR			=	src
OBJ_DIR			=	obj
INC_DIR			=	include

INCLUDES		=	-I$(INC_DIR)

SRC_FILES		=	get_next_line.c \
					get_next_line_utils.c

BONUS_FILES		=	get_next_line_bonus.c \
					get_next_line_utils_bonus.c

OBJS			=	$(addprefix $(OBJ_DIR)/, $(SRC_FILES:.c=.o))
BONUS_OBJS		=	$(addprefix $(OBJ_DIR)/, $(BONUS_FILES:.c=.o))

all: $(NAME)

$(NAME): $(OBJS)
	@rm -f $(NAME)
	@ar rcs $(NAME) $(OBJS)
	@echo "✅ $(NAME) created (mandatory)"

bonus: $(BONUS_OBJS)
	@rm -f $(NAME)
	@ar rcs $(NAME) $(BONUS_OBJS)
	@echo "✅ $(NAME) created (bonus: multiple fds)"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(wildcard $(INC_DIR)/*.h) | $(OBJ_DIR)
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@rm -rf $(OBJ_DIR)
	@echo "🧹 Object files removed."

fclean: clean
	@rm -f $(NAME)
	@echo "🗑️  Library removed."

re: fclean all

.PHONY: all bonus clean fclean re

*This project has been created as part of the 42 curriculum by svaladar.*

<p align="center">
  <img src="https://raw.githubusercontent.com/ayogun/42-project-badges/main/badges/get_next_linem.png" alt="get_next_line badge"/>
</p>

# get_next_line

## Description

`get_next_line` is a C function that reads a file descriptor **one line at a time**. Each call returns the next line, including the trailing `\n` if there is one, or `NULL` when there is nothing left to read or an error occurs.

The goal of the project is to learn about **static variables**, how `read()` works with a fixed buffer size, and how to manage heap memory carefully so that nothing leaks between calls.

```c
char *get_next_line(int fd);
```

### Algorithm

The function keeps a **static stash**: a heap string holding everything that was read from the file but not yet returned.

1. **Read into the stash** (`read_to_stash`): while the stash has no `\n` and `read()` still returns data, read `BUFFER_SIZE` bytes into a temporary buffer and append it to the stash with `ft_gnl_strjoin`.
2. **Extract the line** (`ft_extract_line`): copy the stash up to and including the first `\n` (or up to the end, for the last line) into a new string. This is the return value.
3. **Update the stash** (`ft_update_stash`): keep only what comes after the returned line and free the old stash. When nothing is left, the stash is freed and set to `NULL`.

**Why this approach**

- Reading stops as soon as a `\n` is in the stash, so the function never reads more than it needs for the current line, whatever `BUFFER_SIZE` is (1, 42 or 10 000 000).
- Leftover bytes stay in the stash, so data that came after a `\n` in the last `read()` is not lost.
- Only one static variable is used, and it always points to a heap string or `NULL`. On a read error the stash is freed, so no memory leaks.
- `ft_gnl_strjoin` frees its first argument, which keeps the read loop short and avoids leaks while the stash grows.

### Bonus: multiple file descriptors

The bonus version reads from **several file descriptors at the same time** without mixing their lines, still with a single static variable:

```c
static char	*stash[FD_MAX];
```

Each fd gets its own slot in the array, so calling `get_next_line(3)`, `get_next_line(4)` and `get_next_line(3)` again continues each file where it stopped. `FD_MAX` defaults to 1024 (the usual `ulimit -n`) and can be changed with `-D FD_MAX=n`; any fd outside `0 .. FD_MAX - 1` returns `NULL`.

### Project structure

```
GNL/
├── include/
│   ├── get_next_line.h          # prototypes and default BUFFER_SIZE (42)
│   └── get_next_line_bonus.h    # same, plus FD_MAX (1024)
├── src/
│   ├── get_next_line.c          # get_next_line() and the read loop
│   ├── get_next_line_utils.c    # strlen, strchr, strjoin, line extraction, stash update
│   ├── get_next_line_bonus.c    # multi-fd version
│   └── get_next_line_utils_bonus.c
└── Makefile                     # objects are built in obj/
```

This repository is also a submodule of [libft](https://github.com/Soppinha/libft), which uses the bonus version.

## Instructions

### Compilation

The function is meant to be compiled together with your own code. The buffer size can be set with `-D BUFFER_SIZE=n`:

```bash
cc -Wall -Wextra -Werror -D BUFFER_SIZE=42 -Iinclude src/get_next_line.c src/get_next_line_utils.c main.c
# bonus
cc -Wall -Wextra -Werror -D BUFFER_SIZE=42 -Iinclude src/get_next_line_bonus.c src/get_next_line_utils_bonus.c main.c
```

The repository also ships a `Makefile` that builds a static library:

```bash
make          # builds libgnl.a (mandatory)
make bonus    # rebuilds libgnl.a with the bonus (multiple fds)
make clean    # removes object files
make fclean   # removes object files and the library
make re       # rebuilds everything
```

### Usage example

```c
#include <fcntl.h>
#include <stdio.h>
#include "get_next_line.h"

int main(void)
{
    int   fd = open("file.txt", O_RDONLY);
    char  *line;

    while ((line = get_next_line(fd)) != NULL)
    {
        printf("%s", line);
        free(line);
    }
    close(fd);
    return (0);
}
```

Each returned line is allocated with `malloc` and must be freed by the caller.

## Resources

- `man 2 read`, `man 3 malloc`
- [Static variables in C – GeeksforGeeks](https://www.geeksforgeeks.org/static-variables-in-c/)
- [File descriptors – Wikipedia](https://en.wikipedia.org/wiki/File_descriptor)
- [Tripouille/gnlTester](https://github.com/Tripouille/gnlTester), a tester for this project

### AI usage

AI was used to draft this README from the source code. The mandatory part was written by the author; the bonus (multi-fd stash) and the folder reorganization were done with AI assistance and reviewed and tested by the author.

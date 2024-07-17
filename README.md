# Base Native Linux Default Project Structure

# Instructions
- The whole project can be build, tested, analyzed, or health checked from the root
  project folder by running the `scripts/Project.sh` script. This script must be run
  from the root project folder, otherwise it won't provide the correct output.

  REQUIREMENT: Project.sh must be executed from the root project folder. For example,
               running the script should always follow this method: `./scripts/Project.sh -<flag>`

- Run `./scripts/Project.sh -h` to get a overview of possible flags to pass to the
  script to perform various actions on the project, like: build, unit test, analyze,
  and check the health of the code A.K.A code coverage

# Default Thread Setup
- By default, the threads that are created in this project is not bound to a core. What I mean is 
  no thread's affinity is set to run on a specific core of the cpu. Therefore, if you want to let
  each thread run on a specified cpu core you need to modify the `Services.h` class to use the
  two argument constructor of `RealtimeThread.h` class. The second argument allows you to specify
  the core number on which you want to bind the thread to. 

# Run Unit Tests From Vim
- To run unit tests, you must create and set an environment variable called PROJECT_TEST_DIR = `/path/to/project/test/dir`
  `echo "PROJECT_TEST_DIR=</path/to/project/test/dir>" » ~/.bashrc`
  `source ~/.bashrc`
- Add these two commands to your ~/.vimrc file.
  `autocmd BufWritePost $PROJECT_TEST_DIR/* !sudo -E make -s`
  `autocmd BufWritePost $PROJECT_TEST_DIR/* !sudo -E make -s clean`


# Run Unit Tests Without Vim
- Because the code uses `sched_setscheduler()`, we need to use `sudo -E` when calling make to `preserve` the environment.
  `sudo -E make -s`

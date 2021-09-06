-- q.lua
skynet_context_new(const char * name="snlua", const char *param="bootstrap") {
        //查询mod对象是否已存在，不存在就根据name查找文件加载创建
        struct skynet_module * mod = skynet_module_query(name="snlua");
        ...
        //调用mod的create()方法,这里调用了 snlua_create
        void *inst = skynet_module_instance_create(mod);
        //为lua服务new一个skynet_context的c对象
        struct skynet_context * ctx = skynet_malloc(sizeof(*ctx));
        ...
        //为服务的ctx创建一个message_queue
        struct message_queue * queue = ctx->queue = skynet_mq_create(ctx->handle);
        //调用对象的init方法,这里是 snlua_init(snlua_create(),ctx,"bootstrap")
        int r = skynet_module_instance_init(mod, inst, ctx, param);
        if(r==0){        //0表示成功
            //成功以后，把服务的message_queue放入global_queue全局队列中
            skynet_globalmq_push(queue);
        }
    }

module "network"{

    source      = "./modules/network"

    project_id  = var.project_id
}

module "iam"{

    source          = "./modules/iam"

    project_id      = var.project_id
    project_number  = var.project_number
}

module "kubernetes"{

    source      = "./modules/kubernetes"

    project_id  = var.project_id
    network     = module.network.network
    subnet_prod = module.network.subnet_prod
    subnet_stag = module.network.subnet_stag
    kube_sa     = module.iam.kube_sa
}

module "artifact"{

    source      = "./modules/artifact"

    project_id  = var.project_id
}

module "cloudbuild"{

    source          = "./modules/cloudbuild"

    project_id      = var.project_id
    image_name      = var.image_name
    git_uri         = var.git_uri
    git_install_id  = var.git_install_id
    secret_git      = var.secret_git
    repo_name       = module.artifact.repo_name
    build_sa        = module.iam.build_sa
}

module "clouddeploy"{
    
    source          = "./modules/clouddeploy"

    project_id      = var.project_id
    prod_cluster_id = module.kubernetes.prod_cluster_id
    stag_cluster_id = module.kubernetes.stag_cluster_id
}